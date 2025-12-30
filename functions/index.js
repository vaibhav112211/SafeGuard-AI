const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

const express = require("express");
const app = express();

app.use(express.json());

// ---- SIMPLE AI LOGIC ----
function analyzeContent(text) {
  const categories = {
    sexual: ["sex", "porn", "xxx", "nude", "adult"],
    violence: ["kill", "blood", "murder", "weapon"],
    abuse: ["abuse", "hate", "idiot", "stupid"],
  };

  let score = 0;
  let detectedCategory = "safe";

  for (const category in categories) {
    for (const word of categories[category]) {
      if (text.toLowerCase().includes(word)) {
        score += 0.3;
        detectedCategory = category;
      }
    }
  }

  return {
    score: Math.min(score, 1),
    category: detectedCategory,
  };
}

async function verifyFirebaseToken(req, res, next) {
  const authHeader = req.headers.authorization;

  // 1. Check if Authorization header exists
  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({ error: "Unauthorized: No token" });
  }

  // 2. Extract token
  const token = authHeader.split("Bearer ")[1];

  try {
    // 3. Verify token with Firebase
    const decodedToken = await admin.auth().verifyIdToken(token);

    // 4. Attach user info to request
    req.user = decodedToken;

    next(); // allow API to continue
  } catch (error) {
    return res.status(401).json({ error: "Unauthorized: Invalid token" });
  }
}

async function logEventToFirestore(eventData) {
  await admin
    .firestore()
    .collection("events")
    .add({
      ...eventData,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });
}

async function sendParentNotification(parentId, message) {
  // This is a mock notification logic for now
  console.log("🔔 Parent Notification");
  console.log("Parent ID:", parentId);
  console.log("Message:", message);
}

// ---- MAIN API ----
app.post("/analyze", verifyFirebaseToken, async (req, res) => {
  try {
    const userId = req.user.uid;
    const { childId, url, content } = req.body;

    if (!childId || !content) {
      return res.status(400).json({ error: "Invalid request" });
    }

    const analysis = analyzeContent(content);
    const score = analysis.score;
    const category = analysis.category;

    // Example age-based threshold
    let threshold = 0.7;

    // For younger children, stricter rules
    if (childId && childId.includes("child")) {
      threshold = 0.4;
    }

    let decision = "allow";
    let severity = "low";

    if (score >= threshold) {
      decision = "block";
      severity = "high";
    } else if (score >= 0.4) {
      decision = "warn";
      severity = "medium";
    }

    await logEventToFirestore({
      childId,
      parentId: req.user.uid,
      url: url || "unknown",
      decision,
      severity,
      score,
      category,
    });

    if (severity === "high") {
      const parentId = req.user.uid;

      await sendParentNotification(
        parentId,
        `High-risk ${category} content blocked for your child`
      );
    }

    res.json({ decision, severity, score });
  } catch (error) {
    console.error(error);
    res.status(500).json({ error: "Server error" });
  }
});

// ---- EXPORT API ----
exports.api = functions.https.onRequest(app);
