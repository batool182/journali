import SwiftUI

struct SplashView: View {
    
    
    
    var body: some View {
        ZStack {
            // خلفية متدرجة: من الأسود فوق للرمادي الغامق تحت
            LinearGradient(
                colors: [Color.black, Color(white: 0.08)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Image("SplashIcon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                
                Text("Journali")
                    .font(.system(size: 42, weight: .black))
                    .foregroundStyle(Color.primaryText)
                
                Text("Your thoughts, your story")
                    .font(.system(size: 18, weight: .light))
                    .foregroundStyle(Color.secondaryText)
            }
        }
    }
}

#Preview {
    SplashView()
}
