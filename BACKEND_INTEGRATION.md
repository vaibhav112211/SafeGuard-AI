# SafeGuard AI - Backend Integration Guide

## 🎯 What's Been Set Up

### Backend (Firebase Functions)

✅ Content analysis API with AI logic
✅ Firebase Authentication middleware
✅ Age-based threshold filtering
✅ Firestore event logging
✅ Parent notification system

### Frontend (Flutter)

✅ API Service for backend communication
✅ Content Monitor Provider
✅ Firebase integration
✅ Test screen for API testing

## 🚀 How to Run

### 1. Start Backend (Firebase Emulator)

```bash
cd functions
npm install
cd ..
firebase emulators:start
```

The API will be available at: `http://127.0.0.1:5001/safeguardai-95296/us-central1/api`

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Run Flutter App

```bash
flutter run
```

## 🧪 Testing the Integration

### Option 1: Use the Test Screen

Navigate to the Test Backend Screen in your app and try:

- Safe content: "Hello, how are you?"
- Warning: "I hate this stupid thing"
- Blocked: "xxx adult porn content"

### Option 2: Use Postman/cURL

First, get a Firebase Auth token from your app, then:

```bash
curl -X POST http://127.0.0.1:5001/safeguardai-95296/us-central1/api/analyze \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_FIREBASE_TOKEN" \
  -d '{
    "childId": "child123",
    "content": "This is adult xxx content",
    "url": "example.com"
  }'
```

Expected response:

```json
{
  "decision": "block",
  "severity": "high",
  "score": 0.9
}
```

## 📁 Key Files

### Backend

- `functions/index.js` - Main API with all logic

### Frontend

- `lib/services/api_service.dart` - API client
- `lib/providers/content_monitor_provider.dart` - State management
- `lib/screens/test_backend_screen.dart` - Test interface
- `lib/main.dart` - Firebase initialization

## 🔧 Configuration

### Switch Between Emulator and Production

In `lib/services/api_service.dart`:

```dart
static const bool useEmulator = true;  // false for production
```

### After Deploying to Firebase

1. Deploy functions:

```bash
firebase deploy --only functions
```

2. Update `useEmulator` to `false` in api_service.dart

## 🎨 How to Use in Your App

```dart
import 'package:provider/provider.dart';
import 'providers/content_monitor_provider.dart';

// In your widget:
final monitor = Provider.of<ContentMonitorProvider>(context, listen: false);

final result = await monitor.analyzeContent(
  childId: currentChild.id,
  content: websiteContent,
  url: currentUrl,
);

if (result['decision'] == 'block') {
  // Block the content
  showBlockedDialog();
} else if (result['decision'] == 'warn') {
  // Show warning
  showWarningDialog();
}
```

## 📊 Firestore Data Structure

Events are stored in `events` collection:

```json
{
  "childId": "child123",
  "parentId": "parentUid123",
  "url": "example.com",
  "decision": "block",
  "severity": "high",
  "score": 0.8,
  "category": "sexual",
  "createdAt": "2025-12-31T10:00:00Z"
}
```

## 🔔 Parent Notifications

When high-severity content is blocked:

```
🔔 Parent Notification
Parent ID: xxxxx
Message: High-risk sexual content blocked for your child
```

## 🎯 Next Steps

1. ✅ Backend and Frontend are connected
2. ⏳ Test with Firebase emulator
3. ⏳ Integrate with your WebView monitoring
4. ⏳ Deploy to production
5. ⏳ Add FCM for real push notifications

## 🐛 Troubleshooting

**"User not authenticated"**

- Make sure Firebase Auth is set up
- User must be logged in to make API calls

**"Connection refused"**

- Start Firebase emulator first
- Check the URL in api_service.dart matches your project

**"Invalid token"**

- Token expired, re-login
- Check Authorization header format

## 📝 Notes

- Age-based filtering: Children with "child" in ID get stricter rules (0.4 threshold vs 0.7)
- All events are logged to Firestore with parent ID
- Backend is secured with Firebase Authentication
- Ready for production deployment!
