# Sistema-deteccion-de-piel
This is the first of two phases for a project focused on gesture recognition related to sign language. Specifically, the ultimate goal of the algorithm is to recognize numbers from 0 to 5 by analyzing images of hands. The system aims to identify areas in images representing potentially hands, fingers, arms, etc. 


<!-- ABOUT THE PROJECT -->
## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

In this project, we are confronted with the challenge of developing a system capable of recognizing skin areas in images that represent hand gestures. The ultimate goal is to count the number of fingers shown in these images, enabling the recognition of numbers 0 to 5 in sign language. To address this problem, we have a dataset divided into two main subsets: the training dataset and the validation dataset.

Each of these subsets is organized into two subfolders. The first subfolder contains images used to train our system, depicting hand gestures, sometimes showing parts of the arm or, on occasion, other body parts such as the neck. On the other hand, the second subfolder of the set contains ideal masks indicating the skin areas in the images.

The second subset, the validation set, follows a similar structure. In its first subfolder, we find images similar to those in the training set, but these will be used to evaluate the performance of our system after its development. The second subfolder in the validation set contains ideal masks defining the skin areas in these validation images. However, these ideal masks cannot be used to train our set but merely to assess the efficiency of our system once developed.

Our main objective is to develop algorithms and techniques that allow us to identify skin areas effectively and accurately in hand gesture images. This process will be carried out in two main phases: in the first phase, a color-based skin model will be constructed, and in the second phase, the number of fingers detected in the identified skin areas will be counted.

The expected final result is a system that can recognize numbers 0 to 5 in sign language from the provided images. To evaluate the quality of our system, we will use metrics such as F-Score and computation time. We will also explore how different parameters and techniques affect the system's performance and provide recommendations for future improvements.

In this first part, as previously mentioned, we will focus on the initial phase of the system, the skin detection system.

**Skin Detection System**

The task, essentially, involves a structure capable of detecting the presence of skin in images, whether these skin elements are present or not. The goal of an intelligent system, as this one should be, is to identify its presence as accurately and precisely as possible, with the aim of minimizing both false positives and false negatives.

Initially, we faced a lack of knowledge and, therefore, had to research and evaluate possible techniques to detect skin pixels in images. This involves working primarily in the color space that best suits human skin perception since our goal is to find a chromatic model that maximally facilitates skin pixel detection, one that works effectively for all skin types, regardless of race.

Consequently, we will rely on skin color, as suggested in the proposal. Chrominance associated with human skin is a fairly constant feature, with minimal variation between different individuals, even across different races, as long as the same illumination is present in the scene.

However, there are other factors that will influence the effectiveness of our skin detector. These factors include the size of the database used, i.e., the number of samples used to train our model or the level of detail in the histogram and how it is analyzed.

Ultimately, we must be able to distinguish and separate the pixels of interest from those that are not, leading us to the crucial choice of the color space, which we will address in the following point.

In other considerations, we must also contemplate possible post-processing steps, such as morphological operations, filtering, contour detection, region filling, and shadow removal. All these aspects have been addressed and thoroughly analyzed to improve the effectiveness and performance of our system.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- USAGE EXAMPLES -->
## Usage

_For examples, please refer to the Documentation

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

Pol Buitrago Esteve - polbtr@gmail.com

Project Link: [https://github.com/pol-buitrago/Sistema-deteccion-de-piel
](https://github.com/pol-buitrago/Sistema-deteccion-de-piel
)

<p align="right">(<a href="#readme-top">back to top</a>)</p>




