import { SOUNDS, Sound, PlayerState } from '../model/SoundModel';
import { audioService } from '../service/AudioPlayerService';

interface DetailParams {
  soundIndex: number;
}

@Component
export struct Index {
  @Consume('navPathStack') navPathStack: NavPathStack;
  @State playerState: PlayerState = PlayerState.STOPPED;

  aboutToAppear() {
    // Set callback
    audioService.setCallback((state: PlayerState) => {
      this.playerState = state;
    });
  }

  aboutToDisappear() {
    // Do nothing when Index closes, keep AVSession active
    console.info('Index - Page closed');
  }

  build() {
    NavDestination() {
      Column() {
        // Header
        Text('Rain & Relax 🌧️')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .fontColor('#2C3E50')
          .margin(20)

        // Subtitle
        Text('Choose a sound to relax')
          .fontSize(14)
          .fontColor('#7F8C8D')
          .margin({ top: -10, bottom: 20 })

        // Sound Grid
        Grid() {
          ForEach(SOUNDS, (sound: Sound, index: number) => {
            GridItem() {
              Column() {
                Text(sound.icon)
                  .fontSize(40)
                  .margin({ bottom: 8 })

                Text(sound.name)
                  .fontSize(13)
                  .fontColor('#2C3E50')
                  .fontWeight(FontWeight.Medium)
                  .textAlign(TextAlign.Center)
                  .maxLines(2)
              }
              .width('100%')
              .height(110)
              .backgroundColor('#FFFFFF')
              .borderRadius(12)
              .justifyContent(FlexAlign.Center)
              .shadow({ radius: 5, color: '#00000015' })
              .onClick(() => {
                let params: DetailParams = { soundIndex: index };
                this.navPathStack.pushPathByName('DetailPage', params);
              })
            }
          }, (sound: Sound, index: number) => sound.name + index)        }
        .columnsTemplate('1fr 1fr')
        .rowsGap(15)
        .columnsGap(15)
        .width('90%')
        .layoutWeight(1)
        .margin({ top: 10 })
      }
      .width('100%')
      .height('100%')
      .backgroundColor('#F5F6FA')
    }
    .hideTitleBar(true)
  }
}

@Builder
export function IndexPageBuilder() {
  Index();
}