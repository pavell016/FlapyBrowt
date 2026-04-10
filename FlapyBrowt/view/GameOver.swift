import SwiftUI

struct GameOver: View {
    let score: Int
    let onRestart: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea() // Fondo sólido para que no se vea el juego
            
            VStack(spacing: 30) {
                Text("HAS PERDIDO")
                    .font(.system(size: 40, weight: .black))
                    .foregroundColor(.red)
                
                Text("\(score)")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.white)
                
                Button(action: onRestart) {
                    Text("VOLVER A INTENTAR")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .padding(.horizontal, 50)
            }
        }
    }
}
