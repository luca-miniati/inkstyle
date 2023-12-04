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