import { useState } from "react";
import axios from "axios";
import jsPDF from "jspdf";
import "./App.css";

function App() {
  const [file, setFile] = useState(null);
  const [preview, setPreview] = useState(null);
  const [result, setResult] = useState(null);
  const [loading, setLoading] = useState(false);
  const [history, setHistory] = useState([]);

  const handleFileChange = (e) => {
    const selectedFile = e.target.files[0];

    if (selectedFile) {
      setFile(selectedFile);
      setPreview(URL.createObjectURL(selectedFile));
    }
  };

  const handleReset = () => {
    setFile(null);
    setPreview(null);
    setResult(null);

    const fileInput = document.querySelector(
      'input[type="file"]'
    );

    if (fileInput) {
      fileInput.value = "";
    }
  };

  const getDiseaseStatus = (disease) => {
    if (disease.toLowerCase().includes("healthy")) {
      return {
        text: "🟢 Healthy",
        color: "#22c55e",
      };
    }

    return {
      text: "🔴 Diseased",
      color: "#ef4444",
    };
  };

  const handlePredict = async () => {
    if (!file) {
      alert("Please select an image");
      return;
    }

    const formData = new FormData();
    formData.append("file", file);

    try {
      setLoading(true);

      const response = await axios.post(
        "http://127.0.0.1:8000/disease/predict",
        formData
      );

      setResult(response.data);

      setHistory((prev) => [
        {
          disease: response.data.prediction.disease,
          confidence: response.data.prediction.confidence,
        },
        ...prev,
      ]);
    } catch (error) {
      console.error(error);
      alert("API Error");
    } finally {
      setLoading(false);
    }
  };

  const downloadPDF = () => {
    if (!result) return;

    const doc = new jsPDF();

    doc.setFontSize(18);
    doc.text("AgriVision AI Report", 20, 20);

    doc.setFontSize(12);

    doc.text(
      `Disease: ${result.prediction.disease}`,
      20,
      40
    );

    doc.text(
      `Confidence: ${result.prediction.confidence}%`,
      20,
      50
    );

    doc.text(
      `Symptoms: ${result.disease_info.symptoms}`,
      20,
      70
    );

    doc.text(
      `Cause: ${result.disease_info.cause}`,
      20,
      90
    );

    doc.text(
      `Treatment: ${result.disease_info.treatment}`,
      20,
      110
    );

    doc.save("AgriVision_Report.pdf");
  };

  return (
    <div className="app">
      <h1 className="title">🌱 AgriVision AI</h1>

      <input
        type="file"
        accept="image/*"
        onChange={handleFileChange}
      />

      <br />
      <br />

      {preview && (
        <img
          src={preview}
          alt="preview"
          className="preview"
        />
      )}

      <br />
      <br />

      <button
        onClick={handlePredict}
        disabled={loading}
        className="predict-btn"
      >
        {loading
          ? "Predicting..."
          : "Predict Disease"}
      </button>

      <button
        onClick={handleReset}
        className="predict-btn"
        style={{
          marginLeft: "10px",
          backgroundColor: "#ef4444",
        }}
      >
        Reset
      </button>

      {result && (
        <div className="result-card">
          <h2>Prediction Result</h2>

          <p>
            <strong>Disease:</strong>{" "}
            {result.prediction.disease}
          </p>

          <div
            style={{
              display: "inline-block",
              padding: "8px 15px",
              borderRadius: "20px",
              backgroundColor:
                getDiseaseStatus(
                  result.prediction.disease
                ).color,
              color: "white",
              fontWeight: "bold",
              marginBottom: "15px",
            }}
          >
            {
              getDiseaseStatus(
                result.prediction.disease
              ).text
            }
          </div>

          <p>
            <strong>Confidence:</strong>{" "}
            {result.prediction.confidence}%
          </p>

          <div className="progress">
            <div
              className="progress-bar"
              style={{
                width: `${result.prediction.confidence}%`,
              }}
            ></div>
          </div>

          <br />

          <p>
            <strong>Symptoms:</strong>{" "}
            {result.disease_info?.symptoms}
          </p>

          <p>
            <strong>Cause:</strong>{" "}
            {result.disease_info?.cause}
          </p>

          <p>
            <strong>Treatment:</strong>{" "}
            {result.disease_info?.treatment}
          </p>

          <button
            onClick={downloadPDF}
            className="predict-btn"
          >
            📄 Download PDF Report
          </button>
        </div>
      )}

      {history.length > 0 && (
        <div className="result-card">
          <h2>Prediction History</h2>

          {history.map((item, index) => (
            <p key={index}>
              🌿 {item.disease} — {item.confidence}%
            </p>
          ))}
        </div>
      )}
    </div>
  );
}

export default App;