# Docker Facebook Demucs
This repository dockerizes [Facebook Demucs](https://github.com/facebookresearch/demucs)
to split music tracks into different tracks (bass, drums, voice, others).

## Usage
### 1. Clone this repository
```bash
git clone https://github.com/xserrat/docker-facebook-demucs.git demucs
```
### 2. Split a music track
1. Copy the track you want to split into the `input` folder (e.g., `input/mysong.mp3`).
2. Execute `demucs` via the `run` job in the `Makefile`, specifying the `track` argument with only the name of the file:
```bash
make run track=mysong.mp3
```

This process will take some time the first time it is run, as the execution will:
* Download the Docker image that is setup to run the `facebook demucs` script.
* Download the pretrained models.
* Execute `demucs` to split the track.

Subsequent runs will not need to download the Docker image or download the models, unless the model specified has not yet been used.

#### Options
The following options are available when splitting music tracks with the `run` job:

Option | Default Value | Description
--- | --- | ---
`gpu`       | `false` | Enable Nvidia CUDA support (requires an Nvidia GPU).
`model`     | `demucs`| The model used for audio separation. See https://github.com/facebookresearch/demucs#separating-tracks for a list of available models to use.
`mp3output` | `false` | Output separated audio in `mp3` format instead of the default `wav` format.

Example commands:
```bash
# Use the "fine tuned" demucs model
make run track=mysong.mp3 model=htdemucs_ft

# Enable Nvidia CUDA support and output separated audio in mp3 format
make run track=mysong.mp3 gpu=true mp3output=true
```

## License
This repository is released under the MIT license as found in the [LICENSE](LICENSE) file.
