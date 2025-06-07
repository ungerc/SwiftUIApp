import SwiftUI

public struct GoalsView: View {
    @Environment(GoalViewModel.self) private var goalViewModel
    @State private var showingAddGoal = false
    
    public init() {}
    
    public var body: some View {
        List {
                if goalViewModel.goals.isEmpty {
                    Text("No goals set yet")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                } else {
                    Section(header: Text("In Progress")) {
                        ForEach(goalViewModel.inProgressGoals) { goal in
                            NavigationLink(destination: GoalDetailView(goal: goal).environment(goalViewModel)) {
                                GoalRow(goal: goal)
                            }
                        }
                        .onDelete { indexSet in
                            Task {
                                for index in indexSet {
                                    let goal = goalViewModel.inProgressGoals[index]
                                    await goalViewModel.deleteGoal(id: goal.id)
                                }
                            }
                        }
                    }
                    
                    if !goalViewModel.completedGoals.isEmpty {
                        Section(header: Text("Completed")) {
                            ForEach(goalViewModel.completedGoals) { goal in
                                NavigationLink(destination: GoalDetailView(goal: goal).environment(goalViewModel)) {
                                    GoalRow(goal: goal)
                                }
                            }
                            .onDelete { indexSet in
                                Task {
                                    for index in indexSet {
                                        let goal = goalViewModel.completedGoals[index]
                                        await goalViewModel.deleteGoal(id: goal.id)
                                    }
                                }
                            }
                        }
                    }
                }
        }
        .navigationTitle("Goals")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showingAddGoal = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalView()
                .environment(goalViewModel)
        }
        .refreshable {
            await goalViewModel.fetchGoals()
        }
        .task {
            await goalViewModel.fetchGoals()
        }
        .overlay {
            if goalViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
    }
}

