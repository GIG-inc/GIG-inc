import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.cluster import KMeans, DBSCAN
from sklearn.decomposition import PCA
from sklearn.metrics import silhouette_score, davies_bouldin_score
from sklearn.feature_extraction.text import TfidfVectorizer
import warnings
warnings.filterwarnings('ignore')

# Load your data
# Replace 'your_file.csv' with your actual file path
df = pd.read_csv('your_file.csv', sep='\t')

print("Dataset shape:", df.shape)
print("\nFirst few rows:")
print(df.head())
print("\nData types:")
print(df.dtypes)
print("\nMissing values:")
print(df.isnull().sum())

df['directors'] = df['directors'].fillna('Unknown')
df['cast'] = df['cast'].fillna('Unknown')
df['countries'] = df['countries'].fillna('Unknown')
df['date_added'] = df['date_added'].fillna('Unknown')
df['rating'] = df['rating'].fillna('Unknown')

df['duration_value'] = df['duration'].str.extract('(\d+)').astype(float)

df['is_movie'] = (df['type'] == 'Movie').astype(int)

df['year_added'] = pd.to_datetime(df['date_added'], errors='coerce').dt.year
df['year_added'] = df['year_added'].fillna(df['year_added'].median())

# Count features
df['num_countries'] = df['countries'].str.count(',') + 1
df['num_genres'] = df['listed_in'].str.count(',') + 1
df['num_directors'] = df['directors'].str.count(',') + 1
df['num_cast'] = df['cast'].str.count(',') + 1


df['combined_text'] = (df['title'].fillna('') + ' ' + 
                       df['description'].fillna('') + ' ' + 
                       df['listed_in'].fillna(''))

tfidf = TfidfVectorizer(max_features=50, stop_words='english')
tfidf_matrix = tfidf.fit_transform(df['combined_text'])
tfidf_df = pd.DataFrame(tfidf_matrix.toarray(), 
                        columns=[f'tfidf_{i}' for i in range(tfidf_matrix.shape[1])])
le_rating = LabelEncoder()
df['rating_encoded'] = le_rating.fit_transform(df['rating'])


numerical_features = [
    'release_year', 
    'duration_value', 
    'is_movie',
    'year_added',
    'num_countries',
    'num_genres',
    'num_directors',
    'num_cast',
    'rating_encoded'
]

X_numerical = df[numerical_features].fillna(0)
X_combined = pd.concat([X_numerical.reset_index(drop=True), 
                        tfidf_df.reset_index(drop=True)], axis=1)

scaler = StandardScaler()
X_scaled = scaler.fit_transform(X_combined)

print(f"\nFeature matrix shape: {X_scaled.shape}")


inertias = []
silhouette_scores = []
K_range = range(2, 11)

print("\nCalculating optimal number of clusters...")
for k in K_range:
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    kmeans.fit(X_scaled)
    inertias.append(kmeans.inertia_)
    silhouette_scores.append(silhouette_score(X_scaled, kmeans.labels_))
    print(f"K={k}: Inertia={kmeans.inertia_:.2f}, Silhouette={silhouette_scores[-1]:.3f}")

# Plot elbow curve and silhouette scores
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 5))

ax1.plot(K_range, inertias, 'bo-')
ax1.set_xlabel('Number of Clusters (K)')
ax1.set_ylabel('Inertia')
ax1.set_title('Elbow Method')
ax1.grid(True)

ax2.plot(K_range, silhouette_scores, 'ro-')
ax2.set_xlabel('Number of Clusters (K)')
ax2.set_ylabel('Silhouette Score')
ax2.set_title('Silhouette Score vs K')
ax2.grid(True)

plt.tight_layout()
plt.show()


optimal_k = 5
print(f"\nPerforming K-Means clustering with K={optimal_k}...")

kmeans = KMeans(n_clusters=optimal_k, random_state=42, n_init=10)
df['cluster'] = kmeans.fit_predict(X_scaled)

# Clustering metrics
silhouette_avg = silhouette_score(X_scaled, df['cluster'])
davies_bouldin = davies_bouldin_score(X_scaled, df['cluster'])

print(f"\nClustering Metrics:")
print(f"Silhouette Score: {silhouette_avg:.3f}")
print(f"Davies-Bouldin Index: {davies_bouldin:.3f}")



pca = PCA(n_components=2, random_state=42)
X_pca = pca.fit_transform(X_scaled)

print(f"\nExplained variance ratio: {pca.explained_variance_ratio_}")
print(f"Total variance explained: {sum(pca.explained_variance_ratio_):.3f}")

fig, axes = plt.subplots(2, 2, figsize=(16, 12))

scatter = axes[0, 0].scatter(X_pca[:, 0], X_pca[:, 1], 
                             c=df['cluster'], cmap='viridis', 
                             alpha=0.6, s=30)
axes[0, 0].set_xlabel(f'PC1 ({pca.explained_variance_ratio_[0]:.2%} variance)')
axes[0, 0].set_ylabel(f'PC2 ({pca.explained_variance_ratio_[1]:.2%} variance)')
axes[0, 0].set_title('Clusters Visualization (PCA)')
plt.colorbar(scatter, ax=axes[0, 0], label='Cluster')

cluster_counts = df['cluster'].value_counts().sort_index()
axes[0, 1].bar(cluster_counts.index, cluster_counts.values, color='steelblue')
axes[0, 1].set_xlabel('Cluster')
axes[0, 1].set_ylabel('Number of Items')
axes[0, 1].set_title('Cluster Size Distribution')
axes[0, 1].grid(axis='y', alpha=0.3)

# Type distribution by cluster
type_cluster = pd.crosstab(df['cluster'], df['type'])
type_cluster.plot(kind='bar', ax=axes[1, 0], stacked=True)
axes[1, 0].set_xlabel('Cluster')
axes[1, 0].set_ylabel('Count')
axes[1, 0].set_title('Content Type Distribution by Cluster')
axes[1, 0].legend(title='Type')
axes[1, 0].grid(axis='y', alpha=0.3)

# Average duration by cluster
avg_duration = df.groupby('cluster')['duration_value'].mean()
axes[1, 1].bar(avg_duration.index, avg_duration.values, color='coral')
axes[1, 1].set_xlabel('Cluster')
axes[1, 1].set_ylabel('Average Duration')
axes[1, 1].set_title('Average Duration by Cluster')
axes[1, 1].grid(axis='y', alpha=0.3)

plt.tight_layout()
plt.show()


print("\n" + "="*60)
print("CLUSTER CHARACTERISTICS")
print("="*60)

for cluster_id in sorted(df['cluster'].unique()):
    cluster_data = df[df['cluster'] == cluster_id]
    print(f"\n{'='*60}")
    print(f"CLUSTER {cluster_id} (n={len(cluster_data)})")
    print(f"{'='*60}")
    
    print(f"\nContent Type:")
    print(cluster_data['type'].value_counts())
    
    print(f"\nAverage Release Year: {cluster_data['release_year'].mean():.1f}")
    print(f"Average Duration: {cluster_data['duration_value'].mean():.1f}")
    print(f"Average # of Genres: {cluster_data['num_genres'].mean():.1f}")
    
    # Top ratings
    print(f"\nTop Ratings:")
    print(cluster_data['rating'].value_counts().head(3))
    
    # Top genres
    print(f"\nTop Genres:")
    all_genres = cluster_data['listed_in'].str.split(', ').explode()
    print(all_genres.value_counts().head(5))
    
    # Sample titles
    print(f"\nSample Titles:")
    samples = cluster_data['title'].sample(min(5, len(cluster_data))).tolist()
    for i, title in enumerate(samples, 1):
        print(f"  {i}. {title}")

output_df = df[['show_id', 'type', 'title', 'release_year', 
                'rating', 'duration', 'listed_in', 'cluster']]
output_df.to_csv('clustered_netflix_data.csv', index=False)
print("\n" + "="*60)
print("Results saved to 'clustered_netflix_data.csv'")
print("="*60)

cluster_summary = df.groupby('cluster').agg({
    'show_id': 'count',
    'release_year': 'mean',
    'duration_value': 'mean',
    'num_genres': 'mean',
    'is_movie': lambda x: (x == 1).sum() / len(x) * 100
}).round(2)
cluster_summary.columns = ['Count', 'Avg_Release_Year', 'Avg_Duration', 
                           'Avg_Genres', 'Movie_Percentage']
print("\nCluster Summary:")
print(cluster_summary)