import SwiftUI
import SpriteKit

struct ContentView: View {
    @StateObject var vm = ViewModel()

    var gameScene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: 375, height: 812)
        scene.scaleMode = .aspectFill
        scene.vm = vm
        return scene
    }

    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
                .ignoresSafeArea()
            
            VStack {
                Text("Puntos: \(vm.score)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 40)
                
                if vm.isGameOver {
                    Button(action: {
                        vm.resetGame()
                    }) {
                        Text("Reiniciar")
                            .font(.headline)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                Spacer()
            }
        }
    }
}
