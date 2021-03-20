# Introduction and Overview

According to Professors Jason Bramburger and Nathan Kutz, ’Sweet Child
O’ Mine’ by Guns N’ Roses and ’Comfortably Numb’ by Pink Floyd are two
of the greatest rock and roll songs of all time, and thus worthy of our
analysis. We were given a 14 second long portion of the introductory
guitar riff from Sweet Child O’ Mine, and a 60 second segment of the
second guitar solo in Comfortably Numb. We were tasked with:

1.  Reproducing the music score for the guitar riff in the Guns N’ Roses
    clip and the bass line from the Pink Floyd clip.

2.  Filter the frequencies in Comfortably Numb to isolate and recreate
    the bass line.

3.  Filter and isolate the guitar solo in Comfortably Numb.

In order to recreate the music scores from the respective audio clips,
we utilize the Gabor transform to preserve the location of each note in
the song. This allows us to break apart the instruments and the
frequencies of each of the notes played, allowing us to infer the
architecture of the song. To reduce the noise of other instruments and
their overtones, we filter the audio data in Fourier space for each
moment in the Gabor transform to isolate a given range of frequencies.
Similarly, in our recreations of Comfortably Numbs’ bass line and guitar
solo, we filter the audio clip in Fourier Space using the Fourier
Transform to recreate audio files of the isolated instruments.

# Theoretical Background

Critical to decomposing data into individual frequencies, the Fourier
transform is at the heart of our understanding. Since our data is not
continuous, we require the use of the Discrete Fourier Transform, which
approximates the Fourier Series of the inputted discrete data.
\[\hat{x_{k}} = \frac{1}{N} \sum_{n=0}^N x_n (\cos{\frac{2\pi kn}{N}} + i\sin{\frac{2\pi kn}{N})} =  \frac{1}{N} \sum_{n=0}^N x_n e^{\frac{2\pi ikn}{N}}
    \label{eqn:dft}\] This transformation is implemented using the Fast
Fourier Transform (FFT), an algorithm for computing the Discrete Fourier
Transform which performs at a pace of `O(NlogN)` when inputting \(2^n\)
points. The speed of this algorithm allows us to compute a related
measure, the Gabor Transform. While the Fourier Transform decomposes a
signal into its corresponding frequencies, information in Fourier space
lacks any location in time. In order to compensate for this, Hungarian
physicist Gábor Dénes created a variation of the Fourier Transform by
filtering the inputted times with a function **g**, which localize the
transformation around the location of the filter. Given the Fourier
Transform of a function **f**:
\[\hat{F}(k)  = \frac{1}{\sqrt{2\pi}} \int_{-\infty}^{\infty} 
    e^{-ikx} f(x) dx
    \label{eqn:ft}\] The Gabor Transform can be found by multiplying by
the filter function \(\mathbf{g}\), often a Gaussian:

\[G[f](t, w)  = \int_{-\infty}^{\infty} 
    f(x) g(x-t) e^{-iwx} dx
    \label{eqn:ft}\] Because of the speed of the Fast Fourier Transform,
this transformation can be computed for smaller windows of the data’s
time frame, across all windows available in the data. This allows us to
localize the frequencies captured by the FFT to a distinct moment in
time, letting us infer information about the location of specific
signals.

# Algorithm Implementation and Development

## Initialization & Pre-Processing

We receive the data from both songs in `.m4a` format, which can be read
as a vector of amplitudes using the `audioread` command in MATLAB. To
prepare for using the Fast Fourier Transform, we initialize a vector
mapping to spectral space, shifting the indices used by the MATLAB
implementation of the Discrete Fourier Transform, and dividing each
value to represent the frequencies in Hertz (\(s^{-1}\)).

## High/Low Pass Filtering

Once we have discovered key frequencies that encompass the full range of
the individual instruments, we create a rectangular filter to isolate
the frequencies of a given instrument, silencing noise created by
others. This is created by creating a vector that corresponds to every
possibly value of frequencies in our domain. The indices of this vector
which correspond to the desired range of frequencies are set to 1, while
all other indices are set to 0.

## Gabor Transform

We use the Gabor Transform to locate frequencies in time. To perform
this transformation which captures information about time and frequency,
we loop over each instant in our time domain and take the Fourier Series
of each window of time. The windows are formed by multiplying a Gaussian
filter around the vector in the time domain centered at the moment in
time, and then the `fft` command is performed upon the now localized
data. When all iterations of this process are viewed together, the
changes in frequencies can be viewed throughout time, letting us pick
out the exact moment certain frequencies are featured.  
  
Non-max suppression is then utilized to denoise unwanted frequencies and
overtones. This is accomplished by finding the strongest frequency in
each iteration of the loop, and centering a Gaussian filter around it.
When applied to the Fourier transform of the window, only the strongest
frequencies remain, i.e., the `max()`. From this point, the frequencies
of the desired instrument can be clearly displayed with a spectrogram of
all of the Fourier transformations through time.

![The notes of the first two measures of the guitar
riff.<span label="fig:2brnot"></span>](gnr2bar.png)

![The notes of the first two measures of the guitar
riff.<span label="fig:2brnot"></span>](notes2bar.png)

# Computational Results

Starting with the guitar riff in Sweet Child ’O Mine, the audio clip was
converted into a vector, and over 0.1 second intervals of the 14 second
clip, a Gaussian filter was created at each time and multiplied by the
original data. We then applied the Fast Fourier Transform to this
product, which stored information about the frequencies in the audio
clip at each time frame. The vectors created at each iteration were then
saved and plotted in Figure [\[fig:spec\]](#fig:spec). The maximum value
from each vector in Fourier space was saved, representing the most
prominent frequency heard at a point in time. To ensure we only record
the frequencies of the guitar, a rectangular filter was later enabled
using the discovered range of frequencies played by the guitar. These
values were then plotted to represent the melody of the guitar riff,
which neatly map up to the actual notes of the song. In
Figure [\[fig:2br\]](#fig:2br), the first two measures are plotted on a
spectrogram, overlaid their respective notes, shown in
Figure [\[fig:2brnot\]](#fig:2brnot). This main riff is repeated with
differing tonic roots, which follow a progression of (C\#, D\#, F\#,
C\#). In Figure [\[fig:notful\]](#fig:notful), these differing notes can
be found at the beginning of every two measures of the clip, while the
rest of the notes in the riff are identical.  

![All notes played by the guitar in this clip. Observe the changing
tonic note at the beginning of every two
measures.<span label="fig:notful"></span>](gnrfreq.png)

![All notes played by the guitar in this clip. Observe the changing
tonic note at the beginning of every two
measures.<span label="fig:notful"></span>](notesfull.png)

We then moved on to the 60 second clip from Comfortably Numb, which
included a much more complex musical transcription, featuring the song’s
second guitar solo, a rhythm guitar, and a bass line that repeats
throughout the track. First we isolated and scored the bass line using a
process identical to isolating the guitar riff in Sweet Child O’ Mine.
The frequencies of the bass were neatly contained between 82 Hz and 123
Hz, or notes ’E’ to ’B’. When this range was targeted using a
rectangular filter, the bass line was shown to repeat 4 times, mainly
playing ’B’, and descending to the ’E’ quickly at the end of each
repetition. This progression can be seen in
Figures [\[fig:bs\]](#fig:bs) and [\[fig:bn\]](#fig:bn). In order to
reproduce the isolated bass line in a new audio file, the rectangular
filter for bass frequencies was applied to the Fourier transform of the
entire song. When reverted back to the time domain using the `ifft` and
`ifftshift` commands, only the bass frequencies remained, which can be
founded attached as ’`comfortably_numb_bass_iso.m4a`’.  
The guitar solo of Comfortably Numb proved more difficult to isolate, as
the frequencies of the guitar solo overlap with the rhythm guitar, which
plays chords corresponding to the notes of the bass line. Because of
this, removing the bass notes with a rectangular filter is not as
effective, but is still largely functional. This file without the bass
notes can also be found attached to this project as
’`comfortably_numb_guitar_solo.m4a`’. This similarly affected the
creation of the guitar solo’s musical transcript, which included maximum
frequencies corresponding to the rhythm guitar. This silenced some notes
from the guitar solo, including some of the rhythm’s notes instead. In
order to reduce this effect, we were forced to make a more precise
attempt at filtering the data. For the majority of the clip, the rhythm
guitar is playing a B minor chord, most notably consisting of notes B
and F\#. To counteract these strong notes and their overtones, a very
specific Gaussian filter was applied to these notes in Fourier space,
which can be seen by the black horizontal bars in
Figure [\[fig:filt\]](#fig:filt). This was effective in removing a
majority of the rhythm guitar, but also removed crucial notes in the
guitar solo which shared the same frequencies with the chord and its
overtones.

![The notes of the bass line throughout the entire ’Comfortably Numb’
audio clip.<span label="fig:bn"></span>](bassspec.PNG)

![The notes of the bass line throughout the entire ’Comfortably Numb’
audio clip.<span label="fig:bn"></span>](bassnotes.PNG)

![The same spectrogram but with major frequencies of the rhythm guitar
muted.<span label="fig:filt"></span>](nofilt.PNG)

![The same spectrogram but with major frequencies of the rhythm guitar
muted.<span label="fig:filt"></span>](filtered.png)

# Summary and Conclusions

Over this project, two songs were analyzed using spectral analysis. This
allowed us to find the frequencies of each instrument and then isolate
them in order to discover which notes were being played and when. This
process was straightforward the Guns N’ Roses clip, which was largely
composed of the guitar notes desired for extraction. For this, we
compiled an exact transcription of the guitar riff’s notes and displayed
the changes the progression underwent. In analyzing Pink Floyd’s
Comfortably Numb, it was found that the conditions were not as suitable
for splitting and transcribing all of the instruments. Due to its
relative isolation in the song, the bass line was extracted and a neat
music score was created for it. However, the guitar solo was difficult
to isolate because of its overlapping frequency ranges and notes with
the rhythm guitar. Spectral filter did not improve this issue, as the
rhythm notes were more prevalent than many of the notes in the guitar
solo.  
  
Overall, the project highlights the difficulties associated with the
Fourier Uncertainty Principle. The Fourier transform is limited in the
sense that it lacks any information about time; however, the Gabor
transform, when iterated across a time frame, helps to encode this
location such that the time of a frequency can be known. While accuracy
about frequency is lost, this method makes our analysis possible. With
it, we have found the melodies to the given songs and have been able to
isolate them.

# MATLAB Functions

  - `[Y, Fs] = audioread(’filename’)` returns a vector Y of the inputted
    audio file, with sample rate Fs.

  - `fft(data)` returns the Discrete Fourier Transform of `data` along
    one dimension, inverting the indices on both sides of the axis.

  - `fftshift(dataf)` returns the elements of `dataf` rearranged to undo
    the shifted indices of the Fast Fourier Transform algorithm. This is
    accomplished on every dimension of `dataf`.

  - `ifft(dataf)` returns the inverse of Discrete Fourier Transform of
    `dataf` along one dimension.

  - `ifftshift(dataf)` returns the elements of `dataf` rearranged to
    align with the shifted indices of the Fast Fourier Transform
    algorithm. This is accomplished on every dimension of `dataf`.

  - `y = linspace(x1,x2,n)` returns a row vector of `n` evenly spaced
    points between `x1` and `x2`.

  - `[M,I] = max(dat, [], ’all’)` returns the maximum value `M` of all
    elements of `dat`. The index of the maximum value amongst the
    entirety of `dat` is stored at
`I`.

# MATLAB Code

<span id="listing:examplecode" label="listing:examplecode">\[listing:examplecode\]</span>

<span id="listing:examplecode" label="listing:examplecode">\[listing:examplecode\]</span>

<span id="listing:examplecode" label="listing:examplecode">\[listing:examplecode\]</span>
