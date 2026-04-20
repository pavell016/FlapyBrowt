import SwiftUI
import SpriteKit

struct ContentView: View {
    @EnvironmentObject var vm: ViewModel
    @State private var scene: GameScene?

    var body: some View {
        ZStack {
            if !vm.isGameStarted {
                // --- PANTALLA DE INICIO ---
                ZStack {
                    Image("browt")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 40) {
                        Text("FLAPPY\nBROWT")
                            .font(.system(size: 45, weight: .black, design: .rounded))
                            .foregroundColor(.blue)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        VStack(spacing: 20) {
                            Button("MODO FÁCIL") {
                                vm.startGame(difficulty: .easy)
                                setupNewGame()
                            }
                            .buttonStyle(DifficultyButtonStyle(color: .green))
                            
                            Button("MODO DIFÍCIL") {
                                vm.startGame(difficulty: .hard)
                                setupNewGame()
                            }
                            .buttonStyle(DifficultyButtonStyle(color: .red))
                        }
                    }
                }
            } else if let gameScene = scene, !vm.isGameOver {
                // --- JUEGO ACTIVO ---
                SpriteView(scene: gameScene)
                    .ignoresSafeArea()
                
                VStack {
                    Text("\(vm.score)")
                        .font(.system(size: 70, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                        .shadow(radius: 4)
                        .padding(.top, 50)
                    Spacer()
                }
            } else if vm.isGameOver {
                GameOver(score: vm.score) {
                    self.scene = nil
                    vm.resetGame()
                }
            }
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

// Componente visual para los botones
struct DifficultyButtonStyle: ButtonStyle {
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .padding()
            .frame(width: 200)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
