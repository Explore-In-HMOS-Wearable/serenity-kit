import LottieAnimation from '../animation/LottieAnimation';
import { ConstantUI } from '../util/ConstantUI';
import { IndexPageBuilder } from './Index';
import { DetailPageBuilder } from './DetailPage';

@Entry
@Component
export struct SplashPage {
  @Provide('navPathStack') navPathStack: NavPathStack = new NavPathStack();

  aboutToAppear() {
    setTimeout(() => {
      this.navPathStack.replacePathByName('Index', null);
    }, 5000);
  }

  @Builder
  PageMap(name: string) {
    if (name === 'Index') {
      IndexPageBuilder();
    } else if (name === 'DetailPage') {
      DetailPageBuilder();
    }
  }

  build() {
    Navigation(this.navPathStack) {
      Column() {
        LottieAnimation({ politeChickyPath: 'resources/rawfile/meditate.json' })
          .width(ConstantUI.FULL_WIDTH)
          .height(ConstantUI.FULL_HEIGHT)
      }
      .width(ConstantUI.FULL_WIDTH)
      .height(ConstantUI.FULL_HEIGHT)
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width(ConstantUI.FULL_WIDTH)
    .height(ConstantUI.FULL_HEIGHT)
    .mode(NavigationMode.Stack)
    .hideTitleBar(true)
    .hideBackButton(true)
    .ignoreLayoutSafeArea()
    .navDestination(this.PageMap)
    .titleMode(NavigationTitleMode.Mini)
  }
}
