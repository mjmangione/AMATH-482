## AMATH 482: Computational Methods for Data Analysis
This repository contains the MATLAB files and reports corresponding to the homework assignments for AMATH 482, Winter quarter 2021.


#### Assignment 1: A Submarine Problem
Given the acoustic frequencies of a volume representing the Puget Sound over a 24 hour period, we were tasked with locating a new class of submarine which emits a specific, unknown frequency. This required us to analyze the data-set in Fourier space, averaging the data to reveal the signature frequency of the submarine. From there, a Gaussian filter was applied to the Fourier space data, eliminating the noise of the initial data-set, allowing us to find the location of the submarine for each sample in time.

#### Assignment 2: Rock & Roll and the Gabor Transform
Given audio files of Sweet Child O’ Mine by Guns N’ Roses and Comfortably Numb by Pink Floyd, we were tasked with using Fourier Analysis to separate the frequencies of each instrument and to identify their musical score. In order to preserve the notes of the songs in time, we utilize the Gabor Transform, as well as Gaussian filtering in Fourier space, to isolate the frequencies of specific instruments.

#### Assignment 3: A Spring-Mass System
In this project, we analyze the movement of a spring through time based upon three distinct videos of the same event. Rather than using the well-understood mathematical relationships of this system, we opt to solve this computationally using Principal Component Analysis. When we combine all three perspectives of the spring, this will reduce the dimensionality and unique angles of the videos, leaving us with the spring's movement along its strict axes of motion.

#### Assignment 4: Classifying Digits
In this assignment, we explore the MNIST dataset, a large collection of over 60,000 images featuring handwritten digits. First, we apply Principle Component Analysis to emphasize the different features of each number, which we use to build tools to classify the digits computationally. First, we build a classifier using Linear Discriminant Analysis, creating a projection from the features to a singular dimension. Then we compare its results with more recent methods, such as Decision Trees and Support Vector Machines.

#### Assignment 5: Background Subtraction in Videos
In this assignment, we use dynamic mode decomposition to isolate and reconstruct the foreground and backgrounds of various videos. This decomposition allows us to isolate movement through time, enabling us to extract and subtract the background from the rest of the video. Specifically, we will experiment on two videos of isolated motion: a person skiing down a mountain, and a race-car driving around a turn.
