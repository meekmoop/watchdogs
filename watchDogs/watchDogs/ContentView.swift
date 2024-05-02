import SwiftUI
import Combine


struct ContentView: View {
    var body: some View {
        TabView {
            PoliticianListView()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Politicians")
                }

            LegislativeTrackerView()
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("Legislation")
                }

            NewsListView()
                .tabItem {
                    Image(systemName: "newspaper")
                    Text("News")
                }
        }
    }
}
struct NewsResponse: Codable {
    let articles: [Article]
}

struct Article: Codable, Identifiable {
    var id: String { url }
    let title: String
    let description: String?
    let url: String
    let source: Source
}

struct Source: Codable {
    let id: String?
    let name: String
}

class NewsViewModel: ObservableObject {
    @Published var articles = [Article]()
    func fetchNews() {
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=4227a9eca395437db43d1083714bc8d0"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                DispatchQueue.main.async {
                    self.articles = (try? JSONDecoder().decode(NewsResponse.self, from: data))?.articles ?? []
                }
            }
        }.resume()
    }
}

struct NewsListView: View {
    @StateObject var viewModel = NewsViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.articles) { article in
                VStack(alignment: .leading) {
                    Text(article.title).font(.headline)
                    Text(article.description ?? "No description available").font(.subheadline)
                }
            }
            .navigationTitle("News")
            .onAppear {
                viewModel.fetchNews()
            }
        }
    }
}

struct PoliticianListView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(politicians, id: \.id) { politician in
                    NavigationLink(destination: PoliticianDetailView(politician: politician)) {
                        PoliticianRowView(politician: politician)
                    }
                }
            }
            .navigationTitle("Politicians")
        }
    }
}

struct PoliticianRowView: View {
    let politician: Politician
    
    var body: some View {
        HStack {
            Image(politician.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            Text(politician.name)
        }
    }
}

struct PoliticianDetailView: View {
    let politician: Politician
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(politician.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 500) // Adjust the height as needed
                    .clipped()
                    .padding(.bottom, 20) // Add padding to the bottom of the image
                
                Text(politician.name)
                    .font(.title)
                    .bold() // Bold the title text
                
                HStack(spacing: 10) { // Arrange buttons horizontally
                    Button(action: {
                        // Action for the phone button
                    }) {
                        VStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            Text("Call")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20) // Add horizontal padding
                    .background(Color.gray)
                    .cornerRadius(10)
                    
                    Button(action: {
                        // Action for the email button
                    }) {
                        VStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            Text("Email")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.gray)
                    .cornerRadius(10)
                    
                    Button(action: {
                        // Action for the location button
                    }) {
                        VStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            Text("Location")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.gray)
                    .cornerRadius(10)
                    
                    Button(action: {
                        // Action for the website button
                    }) {
                        VStack {
                            Image(systemName: "globe")
                                .foregroundColor(.white)
                                .font(.system(size: 20))
                            Text("Website")
                                .foregroundColor(.white)
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 10) // Add horizontal padding
                    .background(Color.gray)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 10.0)
                
                // Add more details about the politician here
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "map.fill")
                        Text("District | \(politician.district)")
                            .multilineTextAlignment(.leading) // Align text to the left
                            .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                    }
                    HStack {
                        Image(systemName: "globe.americas")
                        Text("State | \(politician.state)")
                            .multilineTextAlignment(.leading) // Align text to the left
                            .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                    }
                    HStack {
                        Image(systemName: "person.3.fill")
                        Text("Party | \(politician.party)")
                            .multilineTextAlignment(.leading) // Align text to the left
                            .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                    }
                }
                .padding()
                
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.top) // This will make the image bleed into the top
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(politician.name)
    }
}






// Mock data for demonstration
struct Politician: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let district: String 
    let state: String
    let party: String
}

let politicians = [
    Politician(name: "John Doe", imageName: "politician1", district: "District 1", state: "California", party: "Democratic"),
    Politician(name: "Jane Smith", imageName: "politician2", district: "District 2", state: "New York", party: "Republican"),
    Politician(name: "Robert Johnson", imageName: "politician3", district: "District 3", state: "Texas", party: "Independent")
]



struct LegislativeTrackerView: View {
    let legislations: [Legislation] = [
        Legislation(name: "Bill A", summary: "Summary of Bill A", sponsor: "Sponsor A", committees: "Committees A"),
        Legislation(name: "Bill B", summary: "Summary of Bill B", sponsor: "Sponsor B", committees: "Committees B"),
        Legislation(name: "Bill C", summary: "Summary of Bill C", sponsor: "Sponsor C", committees: "Committees C")
    ]
    
    var body: some View {
        NavigationView {
            List(legislations, id: \.name) { legislation in
                NavigationLink(destination: LegislationDetailView(legislation: legislation)) {
                    VStack(alignment: .leading) {
                        Text(legislation.name).font(.headline)
                        Text(legislation.summary).font(.subheadline)
                    }
                }
            }
            .navigationTitle("Legislation")
        }
    }
}


struct LegislationDetailView: View {
    let legislation: Legislation
    @State private var isSummaryExpanded = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Spacer()
                
                Text(legislation.name)
                    .font(.title)
                    .bold()
                
                DisclosureGroup(isExpanded: $isSummaryExpanded) {
                    Text(legislation.summary)
                        .font(.body)
                } label: {
                    Text("Bill Summary")
                        .font(.headline)
                }
                
                Text("Sponsor: \(legislation.sponsor)")
                    .font(.subheadline)
                    .padding(.top)
                
                Text("Committees: \(legislation.committees)")
                    .font(.subheadline)
                
                LatestActionView(action: "Passed Senate", date: "April 20, 2024")
                    .padding(.vertical, -20.0)
                
                // Add a news blurb
                NewsBlurbView()
                    .padding(.vertical, -15.0)
                
                // Add a tracker view here
                TrackerView()
                    .padding(.top, -14.0)
                
                Spacer()
            }
            .padding()
        }
        .padding(.top, 50.0)
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(legislation.name)

    }
}

struct NewsBlurbView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Related News")
                .font(.title)
                .bold()
            
            // Add your news blurb content here
            Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed eget libero euismod, bibendum ex sit amet, facilisis dui. Donec nec nunc sollicitudin, dapibus velit non, fermentum risus. Nam commodo volutpat erat nec egestas.")
                .font(.body)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}


struct LatestActionView: View {
    let action: String
    let date: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Latest Action")
                    .font(.headline)
                    .bold()
                HStack {
                    Text("Action:")
                    Text(action)
                }
                HStack {
                    Text("Date:")
                    Text(date)
                }
            }
            Spacer() // Add Spacer to extend the bar horizontally
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
        .frame(maxWidth: .infinity) // Extend to the maximum width
    }
}



struct TrackerView: View {
    let steps = [
        "Introduced",
        "Passed House",
        "Passed Senate",
        "To President",
        "Became Law"
    ]
    let currentStep = 3 // Change this to reflect the current step
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Tracker")
                .font(.title)
                .bold()
            
            ForEach(steps.indices, id: \.self) { index in
                let step = steps[index]
                HStack {
                    Text(step)
                        .foregroundColor(index <= currentStep ? .green : .gray)
                    Spacer()
                    if index < steps.count - 1 {
                        Rectangle()
                            .frame(width: 30, height: 3)
                            .foregroundColor(index <= currentStep ? .green : .gray)
                    }
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .padding()
    }
}

struct ProgressBar: View {
    @Binding var progress: CGFloat
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(width: geometry.size.width, height: 10)
                
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: min(max(0, geometry.size.width * progress), geometry.size.width), height: 10)
                    .animation(.linear) // Add animation for smooth progress update
            }
        }
        .frame(height: 10)
    }
}

struct Legislation {
    let name: String
    let summary: String
    let sponsor: String
    let committees: String
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
