import SwiftUI

struct ContentView: View {
    @State private var slotFrame: CGRect = .zero
    @State private var droppedCount: Int = 0
    
    var body: some View {
        VStack {
            Text("Adventure time")
                .font(.callout)
                .fontDesign(.monospaced)
                .padding()
            
            // MARK: - Pink Box Empty Slot
            EmptyCardSlot(emptyCardSlotLineColor: .pink)
                .background(
                    GeometryReader { geo in
                        Color.clear
                            .onAppear { slotFrame = geo.frame(in: .global) }
                            .onChange(of: geo.frame(in: .global)) { _, newValue in
                                slotFrame = newValue
                            }
                    }
                )
            
            // MARK: - Card Decks
            HStack {
                DraggableCard(slotFrame: slotFrame, droppedCount: $droppedCount)
                DraggableCard(slotFrame: slotFrame, droppedCount: $droppedCount)
                DraggableCard(slotFrame: slotFrame, droppedCount: $droppedCount)
            }
            .padding()
        }
        .padding()
    }
}

struct DraggableCard: View {
    let slotFrame: CGRect
    @Binding var droppedCount: Int
    
    @State private var offset: CGSize = .zero
    @State private var isLocked: Bool = false
    @State private var stackIndex: Int = 0
    @State private var cardCenterAtDragStart: CGPoint = .zero
    @State private var fingerOffsetFromCenter: CGSize = .zero
    @State private var hasRecordedStart: Bool = false
    
    // Tweak this to control how tall the pile looks
    private let stackSpacing: CGFloat = 8
    
    var body: some View {
        CardUIView(cardColor: .green)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.black.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.4), radius: 3, x: 0, y: 3)
            .background(
                GeometryReader { geo -> Color in
                    let frame = geo.frame(in: .global)
                    DispatchQueue.main.async {
                        if !hasRecordedStart && offset == .zero {
                            cardCenterAtDragStart = CGPoint(x: frame.midX, y: frame.midY)
                        }
                    }
                    return Color.clear
                }
            )
            .offset(offset)
            .zIndex(isLocked ? Double(stackIndex) : 100)  // dragging card on top; once locked, higher stackIndex = higher layer
            .gesture(
                DragGesture(coordinateSpace: .global)
                    .onChanged { value in
                        guard !isLocked else { return }
                        if !hasRecordedStart {
                            fingerOffsetFromCenter = CGSize(
                                width: value.startLocation.x - cardCenterAtDragStart.x,
                                height: value.startLocation.y - cardCenterAtDragStart.y
                            )
                            hasRecordedStart = true
                        }
                        offset = value.translation
                    }
                    .onEnded { value in
                        guard !isLocked else { return }
                        
                        let cardCenterNow = CGPoint(
                            x: value.location.x - fingerOffsetFromCenter.width,
                            y: value.location.y - fingerOffsetFromCenter.height
                        )
                        
                        if slotFrame.contains(cardCenterNow) {
                            // Claim a position in the pile
                            let myIndex = droppedCount
                            stackIndex = myIndex
                            droppedCount += 1
                            
                            // Each card sits visibly above the previous one
                            let stackLift = CGFloat(myIndex) * stackSpacing
                            
                            print("Card dropped! stackIndex=\(myIndex), lift=\(stackLift)")
                            
                            withAnimation(.spring()) {
                                offset = CGSize(
                                    width: offset.width + (slotFrame.midX - cardCenterNow.x),
                                    height: offset.height + (slotFrame.midY - cardCenterNow.y) - stackLift
                                )
                                isLocked = true
                            }
                        } else {
                            withAnimation(.spring()) {
                                offset = .zero
                            }
                        }
                        
                        hasRecordedStart = false
                    }
            )
    }
}
