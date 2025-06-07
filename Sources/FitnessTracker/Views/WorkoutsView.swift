import SwiftUI

public struct WorkoutsView: View {
    @Environment(WorkoutViewModel.self) private var workoutViewModel
    @State private var showingAddWorkout = false
    
    public init() {}
    
    public var body: some View {
        List {
                if workoutViewModel.workouts.isEmpty {
                    Text("No workouts recorded yet")
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(workoutViewModel.workouts) { workout in
                        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                            WorkoutRow(workout: workout)
                        }
                    }
                    .onDelete { indexSet in
                        Task {
                            for index in indexSet {
                                let workout = workoutViewModel.workouts[index]
                                await workoutViewModel.deleteWorkout(id: workout.id)
                            }
                        }
                    }
                }
        }
        .navigationTitle("Workouts")
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {
                    showingAddWorkout = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddWorkout) {
            AddWorkoutView()
                .environment(workoutViewModel)
        }
        .task {
            await workoutViewModel.fetchWorkouts()
        }
        .refreshable {
            await workoutViewModel.fetchWorkouts()
        }
        .overlay {
            if workoutViewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
    }
}

