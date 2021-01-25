# Docker Facebook Demucs
This repository dockerize the [Facebook Demucs](https://github.com/facebookresearch/demucs)
to split music tracks into different tracks (bass, drums, voice, others).

## Usage
### 1. Clone this repository
```bash
git clone https://github.com/xserrat/docker-facebook-demucs.git demucs
```
### 2. Split a music track
1. Copy the track you want to split into the `input` folder (i.e: `input/mysong.mp3`).
2. Execute Demucs specifying the `track` argument with only the name of the file:
```bash
make run track=mysong.mp3
```

This process will take some time the first time due to the execution will:
* Download the image with the whole needed environment to run the `facebook demucs` script.
* Download the pretrained models
* Execute the python command `demucs.separate` to split the track.

## License
This repository is released under the MIT license as found in the [LICENSE](LICENSE) file.
