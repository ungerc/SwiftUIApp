import SwiftUI

/// A card component for displaying statistics in detail views.
/// Shows an icon, title, and value in a card layout.
struct StatCard: View {
    /// The title of the statistic
    let title: String
    /// The value to display
    let value: String
    /// SF Symbol name for the icon
    let icon: String
    /// Color theme for the icon
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
    }
}
