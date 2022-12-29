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

Note that the standard `demucs` model will be used by default. You can specify a different model to use by passing `model=<model name>` to the `make` command. For example:
```bash
make run track=mysong.mp3 model=htdemucs_ft
```

See https://github.com/facebookresearch/demucs#separating-tracks for a list of available models to use.

This process will take some time the first time it is run, as the execution will:
* Download the Docker image that is setup to run the `facebook demucs` script.
* Download the pretrained models.
* Execute `demucs` to split the track.

Subsequent runs will not need to download the Docker image or download the models, unless the model specified has not yet been used.

## License
This repository is released under the MIT license as found in the [LICENSE](LICENSE) file.
