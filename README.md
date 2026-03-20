# 🛡️ Arcanus (TrustGuard AI Firewall)

Arcanus is a zero-trust, privacy-preserving middleware firewall designed specifically for enterprise AI agents. It acts as a robust security gauntlet between your users and Large Language Models, ensuring that all interactions are strictly monitored, safe, and compliant.

## 🌟 Key Features

The primary architecture utilizes a **3-Layer Security Gauntlet**:

1. **Heuristic Scanner:** Fast, rule-based detection of known patterns of abuse, prompt injection, and accidental PII leakage.
2. **RBAC Engine:** Hardened Role-Based Access Control to comprehensively ensure users can only execute permitted classes of queries.
3. **LLM-as-a-Judge:** Deep semantic analysis of dynamic, complex prompts to catch sophisticated jailbreaks that bypass standard rules.

### 📊 Real-Time Audit Trail
The integrated dashboard provides live monitoring and comprehensive forensic analysis logs of every single prompt and response traversing the network.

## 🏗️ Architecture Stack

- **Backend:** High-performance Python backend powered by **FastAPI**, integrating LangChain for model orchestration, and a robust SQL database.
- **Frontend:** A modern, responsive **Next.js** dashboard showcasing live audit trails, agent statuses, and granular forensic controls.
- **Workflow Automation:** Seamlessly integrated with n8n for agent workflows.

## 🚀 Getting Started

### Backend Setup

1. Navigate to the `backend` directory.
2. Activate your virtual environment:
   ```bash
   # On Windows
   .venv\Scripts\activate
   ```
3. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
4. Start the FastAPI server using Uvicorn:
   ```bash
   uvicorn app.main:app --reload
   ```

### Frontend Setup

1. Navigate to the `frontend` directory.
2. Install Node dependencies:
   ```bash
   npm install
   ```
3. Start the Next.js development server:
   ```bash
   npm run dev
   ```
4. Open your browser to `http://localhost:3000` to view the Live Dashboard.
