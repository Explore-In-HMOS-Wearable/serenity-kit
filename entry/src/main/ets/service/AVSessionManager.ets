import { avSession } from '@kit.AVSessionKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';

export class AVSessionManager {
  private session: avSession.AVSession | null = null;
  private isSessionActive: boolean = false;
  private context: common.UIAbilityContext | null = null;

  // Set context from outside
  setContext(context: common.UIAbilityContext): void {
    this.context = context;
  }

  async init(): Promise<void> {
    try {
      if (!this.context) {
        console.error('AVSessionManager - Context not set');
        return;
      }

      // Create session
      this.session = await avSession.createAVSession(
        this.context,
        'Rain & Relax',
        'audio'
      );

      console.info('AVSessionManager - Session created');

      // Activate session
      await this.session.activate();
      this.isSessionActive = true;
      console.info('AVSessionManager - Session activated');

      // Add control command listeners
      this.setupControlListeners();

    } catch (error) {
      const err = error as BusinessError;
      console.error('AVSessionManager - Init error:', err.code, err.message);
    }
  }

  private setupControlListeners(): void {
    if (!this.session) return;

    // Play command
    this.session.on('play', () => {
      console.info('AVSessionManager - Play command received');
      // Notify AudioPlayerService
    });

    // Pause command
    this.session.on('pause', () => {
      console.info('AVSessionManager - Pause command received');
      // Notify AudioPlayerService
    });

    // Stop command
    this.session.on('stop', () => {
      console.info('AVSessionManager - Stop command received');
      // Notify AudioPlayerService
    });
  }

  async updateMetadata(title: string, artist: string): Promise<void> {
    if (!this.session) return;

    try {
      const metadata: avSession.AVMetadata = {
        assetId: '0',
        title: title,
        artist: artist,
        album: 'Rain & Relax',
        duration: 0
      };

      await this.session.setAVMetadata(metadata);
      console.info('AVSessionManager - Metadata updated:', title);
    } catch (error) {
      const err = error as BusinessError;
      console.error('AVSessionManager - Metadata error:', err.code, err.message);
    }
  }

  async updatePlaybackState(state: avSession.AVPlaybackState): Promise<void> {
    if (!this.session) return;

    try {
      await this.session.setAVPlaybackState(state);
      console.info('AVSessionManager - Playback state updated');
    } catch (error) {
      const err = error as BusinessError;
      console.error('AVSessionManager - Playback state error:', err.code, err.message);
    }
  }

  async destroy(): Promise<void> {
    if (!this.session) return;

    try {
      if (this.isSessionActive) {
        await this.session.deactivate();
        this.isSessionActive = false;
      }
      await this.session.destroy();
      this.session = null;
      console.info('AVSessionManager - Session destroyed');
    } catch (error) {
      const err = error as BusinessError;
      console.error('AVSessionManager - Destroy error:', err.code, err.message);
    }
  }
}

export const avSessionManager = new AVSessionManager();