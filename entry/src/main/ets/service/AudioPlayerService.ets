import media from '@ohos.multimedia.media';
import { audio } from '@kit.AudioKit';
import { avSession } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { PlayerState, Sound } from '../model/SoundModel';
import { common } from '@kit.AbilityKit';

interface AVError {
  code?: number;
  message?: string;
}

class AudioPlayerService {
  private avPlayer: media.AVPlayer | null = null;
  private avSessionInstance: avSession.AVSession | null = null;
  private currentState: PlayerState = PlayerState.STOPPED;
  private stateCallback: ((state: PlayerState) => void) | null = null;
  private timerHandle: number = -1;
  private isInitializing: boolean = false;
  private currentSound: Sound | null = null;
  private shouldLoop: boolean = true;
  private context: common.UIAbilityContext | null = null;

  constructor() {}

  // Set context from outside
  setContext(context: common.UIAbilityContext): void {
    this.context = context;
  }

  // ✅ AVSession Init
  async initAVSession(): Promise<void> {
    try {
      if (this.avSessionInstance) {
        console.info('AudioPlayerService - AVSession already exists');
        return;
      }

      if (!this.context) {
        console.error('AudioPlayerService - Context not set');
        return;
      }

      this.avSessionInstance = await avSession.createAVSession(
        this.context,
        'Rain & Relax',
        'audio'
      );

      console.info('AudioPlayerService - AVSession created');

      await this.avSessionInstance.activate();
      console.info('AudioPlayerService - AVSession activated');

      this.setupAVSessionListeners();

    } catch (error) {
      const err = error as BusinessError;
      console.error('AudioPlayerService - AVSession init error:', err.code, err.message);
    }
  }

  // ✅ AVSession Listeners
  private setupAVSessionListeners(): void {
    if (!this.avSessionInstance) return;

    this.avSessionInstance.on('play', () => {
      console.info('AudioPlayerService - AVSession play command');
      if (this.currentSound) {
        this.resume();
      }
    });

    this.avSessionInstance.on('pause', () => {
      console.info('AudioPlayerService - AVSession pause command');
      this.pause();
    });

    this.avSessionInstance.on('stop', () => {
      console.info('AudioPlayerService - AVSession stop command');
      this.stop();
    });
  }

  // ✅ AVSession Metadata Update
  private async updateAVSessionMetadata(title: string): Promise<void> {
    if (!this.avSessionInstance) return;

    try {
      const metadata: avSession.AVMetadata = {
        assetId: '0',
        title: title,
        artist: 'Rain & Relax',
        album: 'Relaxation Sounds',
        duration: 0
      };

      await this.avSessionInstance.setAVMetadata(metadata);
      console.info('AudioPlayerService - AVSession metadata updated');
    } catch (error) {
      const err = error as BusinessError;
      console.error('AudioPlayerService - Metadata error:', err.code, err.message);
    }
  }

  // ✅ AVSession Playback State Update
  private async updateAVSessionPlaybackState(state: avSession.PlaybackState): Promise<void> {
    if (!this.avSessionInstance) return;

    try {
      const playbackState: avSession.AVPlaybackState = {
        state: state,
        speed: 1.0,
        position: {
          elapsedTime: this.avPlayer ? this.avPlayer.currentTime : 0,
          updateTime: Date.now()
        }
      };

      await this.avSessionInstance.setAVPlaybackState(playbackState);
      console.info('AudioPlayerService - AVSession playback state updated');
    } catch (error) {
      const err = error as BusinessError;
      console.error('AudioPlayerService - Playback state error:', err.code, err.message);
    }
  }

  private async ensurePlayer(): Promise<boolean> {
    if (this.avPlayer) {
      return true;
    }

    if (this.isInitializing) {
      await new Promise<void>((resolve: (value: void) => void) => {
        setTimeout((): void => resolve(), 100);
      });
      return this.ensurePlayer();
    }

    this.isInitializing = true;
    try {
      this.avPlayer = await media.createAVPlayer();
      this.setupListeners();
      console.info('AudioPlayerService - Player successfully created');

      await this.waitForState('idle', 3000);
      console.info('AudioPlayerService - Player reached idle state');

      this.isInitializing = false;
      return true;
    } catch (error) {
      console.error('AudioPlayerService - Player could not be created:', JSON.stringify(error));
      this.isInitializing = false;
      return false;
    }
  }

  private async waitForState(targetState: string, timeout: number = 10000): Promise<void> {
    return new Promise<void>((resolve: (value: void) => void, reject: (reason?: Error) => void) => {
      const startTime = Date.now();
      const checkState = (): void => {
        if (!this.avPlayer) {
          reject(new Error('Player does not exist'));
          return;
        }

        const currentState = this.avPlayer.state as string;

        if (currentState === targetState) {
          console.info(`AudioPlayerService - ✅ State reached: ${targetState}`);
          resolve();
        } else if (Date.now() - startTime > timeout) {
          console.error(`AudioPlayerService - ❌ Timeout: expected ${targetState}, current: ${currentState}`);
          reject(new Error(`Timeout waiting for ${targetState}`));
        } else {
          setTimeout((): void => checkState(), 50);
        }
      };
      checkState();
    });
  }

  private setupListeners(): void {
    if (!this.avPlayer) return;

    this.avPlayer.on('stateChange', (state: string) => {
      console.info(`AudioPlayerService - 🔄 State Changed: ${state}`);

      switch (state) {
        case 'playing':
          this.currentState = PlayerState.PLAYING;
          if (this.stateCallback) {
            this.stateCallback(this.currentState);
          }
          this.updateAVSessionPlaybackState(avSession.PlaybackState.PLAYBACK_STATE_PLAY);
          break;
        case 'paused':
          this.currentState = PlayerState.PAUSED;
          if (this.stateCallback) {
            this.stateCallback(this.currentState);
          }
          this.updateAVSessionPlaybackState(avSession.PlaybackState.PLAYBACK_STATE_PAUSE);
          break;
        case 'stopped':
        case 'idle':
          this.currentState = PlayerState.STOPPED;
          if (this.stateCallback) {
            this.stateCallback(this.currentState);
          }
          this.updateAVSessionPlaybackState(avSession.PlaybackState.PLAYBACK_STATE_STOP);
          break;
      }
    });

    this.avPlayer.on('error', (error) => {
      const err = error as AVError;
      const code = err.code || -1;
      const msg = err.message || 'Unknown error';

      console.error('AudioPlayerService - ERROR:', JSON.stringify(error));
      console.error('AudioPlayerService - Code:', code, 'Message:', msg);

      // ✅ 5400102 IGNORE
      if (code === 5400102) {
        console.warn('AudioPlayerService - 5400102 ignored');
        return;
      }

      this.currentState = PlayerState.STOPPED;
      if (this.stateCallback) {
        this.stateCallback(this.currentState);
      }
    });

    this.avPlayer.on('endOfStream', () => {
      console.info('AudioPlayerService - Playback completed');
      if (this.shouldLoop && this.avPlayer) {
        console.info('AudioPlayerService - Loop active');
        this.avPlayer.seek(0);
        this.avPlayer.play();
      }
    });
  }

  setCallback(callback: (state: PlayerState) => void): void {
    this.stateCallback = callback;
  }

  async play(sound: Sound): Promise<void> {
    try {
      console.info(`AudioPlayerService - ▶️ Play starting: ${sound.name}`);
      this.currentSound = sound;
      this.shouldLoop = true;

      // ✅ Update AVSession metadata
      await this.updateAVSessionMetadata(sound.name);

      const playerReady = await this.ensurePlayer();
      if (!playerReady || !this.avPlayer) {
        console.error('AudioPlayerService - Player not ready!');
        return;
      }

      const currentNativeState = this.avPlayer.state as string;
      console.info(`AudioPlayerService - Current native state: ${currentNativeState}`);

      // ✅ MUST RETURN TO IDLE STATE
      if (currentNativeState !== 'idle') {
        console.info('AudioPlayerService - Player not idle, resetting...');

        if (currentNativeState === 'playing' || currentNativeState === 'paused' || currentNativeState === 'prepared') {
          try {
            await this.avPlayer.stop();
            console.info('AudioPlayerService - Stopped');
          } catch (e) {
            console.warn('AudioPlayerService - Stop failed:', e);
          }
        }

        await this.avPlayer.reset();
        console.info('AudioPlayerService - Reset');

        await this.waitForState('idle', 3000);
      }

      console.info('AudioPlayerService - Player idle, setting URL...');

      // ✅ SET URL
      this.avPlayer.url = sound.url;
      console.info(`AudioPlayerService - URL set: ${sound.url}`);

      // ✅ WAIT FOR INITIALIZED
      await this.waitForState('initialized', 8000);

      // ✅ SET AudioRendererInfo
      this.avPlayer.audioRendererInfo = {
        usage: audio.StreamUsage.STREAM_USAGE_MUSIC,
        rendererFlags: 0,
      };
      console.info('AudioPlayerService - AudioRendererInfo set');

      // ✅ PREPARE
      await this.avPlayer.prepare();
      console.info('AudioPlayerService - Prepare called');

      await this.waitForState('prepared', 15000);

      // ✅ PLAY
      await this.avPlayer.play();
      console.info('AudioPlayerService - Play called');

    } catch (error) {
      console.error('AudioPlayerService - Play error:', JSON.stringify(error));

      if (this.avPlayer) {
        try {
          await this.avPlayer.reset();
        } catch (e) {
          console.warn('AudioPlayerService - Reset cleanup failed:', e);
        }
      }
    }
  }

  async pause(): Promise<void> {
    try {
      if (!this.avPlayer) return;

      const state = this.avPlayer.state as string;
      if (state === 'playing') {
        await this.avPlayer.pause();
        console.info('AudioPlayerService - Paused');
      }
    } catch (error) {
      console.error('AudioPlayerService - Pause error:', JSON.stringify(error));
    }
  }

  async resume(): Promise<void> {
    try {
      if (!this.avPlayer) return;

      const state = this.avPlayer.state as string;
      if (state === 'paused') {
        await this.avPlayer.play();
        console.info('AudioPlayerService - Resuming');
      }
    } catch (error) {
      console.error('AudioPlayerService - Resume error:', JSON.stringify(error));
    }
  }

  async stop(): Promise<void> {
    try {
      this.clearTimer();
      this.shouldLoop = false;

      if (!this.avPlayer) return;

      const state = this.avPlayer.state as string;
      if (state === 'playing' || state === 'paused' || state === 'prepared') {
        await this.avPlayer.stop();
        console.info('AudioPlayerService - Stopped');
      }
    } catch (error) {
      console.error('AudioPlayerService - Stop error:', JSON.stringify(error));
    }
  }

  setTimer(minutes: number): void {
    this.clearTimer();
    this.timerHandle = setTimeout((): void => {
      console.info('AudioPlayerService - Timer expired');
      this.stop();
    }, minutes * 60 * 1000);
  }

  clearTimer(): void {
    if (this.timerHandle !== -1) {
      clearTimeout(this.timerHandle);
      this.timerHandle = -1;
    }
  }

  async release(): Promise<void> {
    try {
      this.clearTimer();
      this.shouldLoop = false;

      if (this.avPlayer) {
        const state = this.avPlayer.state as string;
        if (state === 'playing' || state === 'paused' || state === 'prepared') {
          await this.avPlayer.stop();
        }
        this.avPlayer.release();
        this.avPlayer = null;
        console.info('AudioPlayerService - Player released');
      }

      // ✅ Clean up AVSession
      if (this.avSessionInstance) {
        await this.avSessionInstance.deactivate();
        await this.avSessionInstance.destroy();
        this.avSessionInstance = null;
        console.info('AudioPlayerService - AVSession destroyed');
      }
    } catch (error) {
      console.error('AudioPlayerService - Release error:', JSON.stringify(error));
    }
  }

  getState(): PlayerState {
    return this.currentState;
  }
}

export const audioService = new AudioPlayerService();