import { SOUNDS, Sound, PlayerState } from '../model/SoundModel';
import { audioService } from '../service/AudioPlayerService';

interface DetailParams {
  soundIndex: number;
}

@Component
export struct DetailPage {
  @Consume('navPathStack') navPathStack: NavPathStack;
  @State soundIndex: number = 0;
  @State playerState: PlayerState = PlayerState.STOPPED;
  @State timer: number = 0;
  @State timerText: string = '';
  @State currentSound: Sound = SOUNDS[0];
  private isAVSessionInitialized: boolean = false;

  async aboutToAppear() {
    // Initialize AVSession only once
    if (!this.isAVSessionInitialized) {
      await audioService.initAVSession();
      this.isAVSessionInitialized = true;
      console.info('DetailPage - AVSession initialized');
    }

    const params = this.navPathStack.getParamByName('DetailPage')[0] as DetailParams;
    this.soundIndex = params.soundIndex || 0;
    this.currentSound = SOUNDS[this.soundIndex];

    audioService.setCallback((state: PlayerState) => {
      this.playerState = state;
    });

    // Start playing sound
    audioService.play(this.currentSound);
  }

  aboutToDisappear() {
    // When page closes, only clear callback, keep AVSession active
    console.info('DetailPage - Page closed, AVSession remains active');
  }

  togglePlay() {
    if (this.playerState === PlayerState.PLAYING) {
      audioService.pause();
    } else {
      audioService.resume();
    }
  }

  stopSound() {
    // On stop, sound stops but AVSession remains active
    audioService.stop();
    this.navPathStack.pop();
  }

  nextSound() {
    let next = (this.soundIndex + 1) % SOUNDS.length;
    this.soundIndex = next;
    this.currentSound = SOUNDS[next];
    audioService.play(this.currentSound);
  }

  previousSound() {
    let prev = this.soundIndex === 0 ? SOUNDS.length - 1 : this.soundIndex - 1;
    this.soundIndex = prev;
    this.currentSound = SOUNDS[prev];
    audioService.play(this.currentSound);
  }

  setTimer(min: number) {
    this.timer = min;
    this.timerText = `${min} min`;
    audioService.setTimer(min);
  }

  build() {
    NavDestination() {
      Scroll() {
        Column() {
          // Header with back button
          Row() {
            Button({ type: ButtonType.Normal }) {
              Text('←')
                .fontSize(18)
                .fontColor('#3498DB')
                .fontWeight(FontWeight.Bold)
            }
            .backgroundColor(Color.Transparent)
            .width(40)
            .onClick(() => this.navPathStack.pop())

            Text('Now Playing')
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
              .fontColor('#2C3E50')
              .layoutWeight(1)
              .textAlign(TextAlign.Center)
          }
          .width('100%')
          .padding({ left: 10, right: 10, top: 5, bottom: 5 })

          // Sound Display
          Column() {
            Text(this.currentSound.icon)
              .fontSize(60)
              .margin({ top: 10, bottom: 10 })

            Text(this.currentSound.name)
              .fontSize(18)
              .fontColor('#2C3E50')
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Center)
              .maxLines(2)
              .margin({ bottom: 5 })

            Text(this.playerState === PlayerState.PLAYING ? '▶️ Playing' : '⏸️ Paused')
              .fontSize(13)
              .fontColor('#7F8C8D')
              .margin({ bottom: 5 })

            if (this.timerText) {
              Text('⏲️ ' + this.timerText)
                .fontSize(12)
                .fontColor('#9B59B6')
                .fontWeight(FontWeight.Bold)
                .margin({ top: 5 })
            }
          }
          .width('95%')
          .padding(15)
          .backgroundColor('#FFFFFF')
          .borderRadius(15)
          .margin({ top: 10, bottom: 10 })

          // Main Play/Pause Button
          Button({ type: ButtonType.Circle }) {
            Text(this.playerState === PlayerState.PLAYING ? '⏸️' : '▶️')
              .fontSize(28)
          }
          .width(70)
          .height(70)
          .backgroundColor('#2ECC71')
          .margin({ top: 5, bottom: 10 })
          .onClick(() => this.togglePlay())

          // Navigation Controls
          Row() {
            Button({ type: ButtonType.Circle }) {
              Text('⏮️')
                .fontSize(18)
            }
            .width(50)
            .height(50)
            .backgroundColor('#3498DB')
            .onClick(() => this.previousSound())

            Button({ type: ButtonType.Circle }) {
              Text('⏭️')
                .fontSize(18)
            }
            .width(50)
            .height(50)
            .backgroundColor('#3498DB')
            .onClick(() => this.nextSound())
          }
          .width('90%')
          .justifyContent(FlexAlign.SpaceEvenly)
          .margin({ bottom: 10 })

          // Stop Button
          Button('⏹️ Stop')
            .onClick(() => this.stopSound())
            .backgroundColor('#E74C3C')
            .fontColor('#FFFFFF')
            .fontSize(14)
            .borderRadius(10)
            .width('90%')
            .height(45)
            .margin({ bottom: 10 })

          // Timer Section
          Column() {
            Text('⏲️ Timer')
              .fontSize(14)
              .fontColor('#2C3E50')
              .fontWeight(FontWeight.Bold)
              .margin({ bottom: 8 })

            Row() {
              Button('5')
                .onClick(() => this.setTimer(5))
                .backgroundColor(this.timer === 5 ? '#9B59B6' : '#BDC3C7')
                .fontColor('#FFFFFF')
                .fontSize(12)
                .borderRadius(8)
                .width('23%')
                .height(40)

              Button('10')
                .onClick(() => this.setTimer(10))
                .backgroundColor(this.timer === 10 ? '#9B59B6' : '#BDC3C7')
                .fontColor('#FFFFFF')
                .fontSize(12)
                .borderRadius(8)
                .width('23%')
                .height(40)

              Button('15')
                .onClick(() => this.setTimer(15))
                .backgroundColor(this.timer === 15 ? '#9B59B6' : '#BDC3C7')
                .fontColor('#FFFFFF')
                .fontSize(12)
                .borderRadius(8)
                .width('23%')
                .height(40)

              Button('✕')
                .onClick(() => {
                  this.timer = 0;
                  this.timerText = '';
                  audioService.clearTimer();
                })
                .backgroundColor('#95A5A6')
                .fontColor('#FFFFFF')
                .fontSize(16)
                .borderRadius(8)
                .width('23%')
                .height(40)
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('95%')
          .padding(12)
          .backgroundColor('#FFFFFF')
          .borderRadius(12)
          .margin({ bottom: 15, top: 5 })
        }
        .width('100%')
        .padding({ bottom: 20 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F6FA')
      .scrollBar(BarState.Off)
    }
    .hideTitleBar(true)
  }
}

@Builder
export function DetailPageBuilder() {
  DetailPage();
}