import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var vm: ViewModel
    // Guardamos la escena en un estado para que no se recree al cambiar el score
    @State private var scene: GameScene?

    var body: some View {
        ZStack {
            if let gameScene = scene, !vm.isGameOver {
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
                
                // HUD de puntos: Esto se redibuja SIN afectar a la escena
                VStack {
                    Text("\(vm.score)")
                        .font(.system(size: 70, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .padding(.top, 50)
                    Spacer()
                }
            } else if vm.isGameOver {
                // Pantalla de pérdida limpia
                GameOver(score: vm.score) {
                    vm.resetGame()
                    setupNewGame() // Creamos escena nueva al reiniciar
                }
            }
        }
        .onAppear {
            setupNewGame()
        }
    }

    func setupNewGame() {
        let newScene = GameScene()
        newScene.size = CGSize(width: 375, height: 812)
        newScene.scaleMode = .aspectFill
        newScene.vm = vm
        self.scene = newScene
    }
}
