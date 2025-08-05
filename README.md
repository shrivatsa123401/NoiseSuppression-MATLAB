[README (1).md](https://github.com/user-attachments/files/21603507/README.1.md)
#  Noise Suppression using Deep Learning in MATLAB

This project implements a deep learning-based approach for speech enhancement by suppressing background noise using MATLAB. It utilizes MATLAB’s **Audio Toolbox** and **Deep Learning Toolbox**, and is trained on the **Microsoft DNS Challenge** dataset.


---

##  Dataset

- **Microsoft DNS Challenge Dataset**
  - A publicly available dataset containing paired clean and noisy audio samples.
  - Ideal for training supervised speech enhancement models.
  - [Dataset Info](https://dns-challenge.microsoft.org)

---

##  Features

- 📢 Real-time or batch-mode noise suppression
- 🎙️ Spectrogram-based input feature extraction
- 🤖 Deep neural network architecture (DNN or CNN-LSTM)
- 📈 Metrics: PESQ, STOI, SNR Improvement

---

##  Requirements

- MATLAB R2020b or later
- Audio Toolbox
- Deep Learning Toolbox

---

##  Getting Started

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/NoiseSuppressionProject.git
   cd NoiseSuppressionProject
   ```

2. **Prepare Data**
   - Place your `clean/` and `noisy/` audio files inside the `data/` folder.

3. **Run Training**
   ```matlab
   run('scripts/trainModel.m')
   ```

4. **Run Testing**
   ```matlab
   run('scripts/testModel.m')
   ```

---

##  Results

Evaluation metrics and audio outputs are saved in the `results/` folder. Sample performance metrics include:
- PESQ score improvement
- STOI score increase
- SNR gain in dB

---

##  Acknowledgements

- Microsoft DNS Challenge for dataset
- MATLAB’s Deep Learning & Audio Toolboxes
- Community contributions and open-source models

---

##  License

This project is licensed under the MIT License. See `LICENSE` file for details.

---

##  Contact

For questions or contributions, please reach out via [GitHub Issues](https://github.com/yourusername/NoiseSuppressionProject/issues).


## Dataset 
- Microsoft DNS Challenge Dataset 

## Author 
- Your Name 
