##### Frontend: Swift
Wow look a flowchart
![[flowchart.png]]
ChatGPT Prompts
I am building a tattoo recommendation app in Flutter. 
##### Backend: Flask API
Endpoints:!
1. `images(n, offset)`
	- Gets `n` images, with `offset`
2. `recommendations(data)`
	- Calls recommendation algorithm

Recommendation Algorithm:
1. Preprocessing
	- Possible: apply blur to bg
2. Feature Extraction
	- Use pretrained model (VGG16, VGG19, ResNet)
	- Possible: train own model
	- Flatten data
3. Vector Embedding
	- Self explanatory
4. Similarity Scoring
	- Cosine similarity
5. User Input
	- Score all images against user's selected images
6. Feedback Loop
	- Adjust algo

## significant progress
First, user opens app
* client sends user id, ratings to api (recommendations endpoint) at this point, ratings are null
* server fetches user embedding from supabase bucket
* server fetches image embeddings from supabase bucket
* server updates user embeddings, using rating image embeddings
* server fetches like 15 image embeddings from supabase bucket
* if user id has user embedding, use it to threshold those cosine similarities
* otherwise, just grab the first 10
* Do this until we have >=10 valid images to recommend
* server send the image_ids of the embeddings to client

forever
* client fetches images from supabase bucket, using image_ids
* client runs card swiper on new images
* client sends user id, ratings to api (algorithm endpoint)
* server fetches user embedding from supabase bucket
* server fetches image embeddings from supabase bucket
* server updates user embeddings, using image embeddings
* server fetches like 15 image embeddings from supabase bucket
* if user id has user embedding, use it to threshold those cosine similarities
* otherwise, just grab the first 10
* Do this until we have >=10 valid images to recommend
* server send the image_ids of the embeddings to client
