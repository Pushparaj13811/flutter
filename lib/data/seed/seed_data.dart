import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SeedData {
  static final _db = FirebaseFirestore.instance;

  static Future<void> seed() async {
    final users = [
      {
        'name': 'Kruti Manani',
        'email': 'kruti@skillexchange.com',
        'password': 'Kruti1234@#\$',
        'role': 'admin',
        'bio': 'Full-stack developer passionate about building meaningful tech. Love mentoring and learning from others.',
        'location': 'Mumbai, India',
        'timezone': 'UTC+5:30',
        'languages': ['English', 'Hindi', 'Gujarati'],
        'skillsToTeach': [
          {'name': 'React', 'category': 'Programming', 'level': 'expert', 'isVerified': true},
          {'name': 'Node.js', 'category': 'Programming', 'level': 'advanced', 'isVerified': true},
          {'name': 'UI/UX Design', 'category': 'Design', 'level': 'intermediate'},
        ],
        'skillsToLearn': [
          {'name': 'Flutter', 'category': 'Programming', 'level': 'beginner'},
          {'name': 'Machine Learning', 'category': 'Science', 'level': 'beginner'},
        ],
        'interests': ['Open Source', 'Tech Communities', 'Teaching'],
        'availability': {'monday': true, 'tuesday': true, 'wednesday': false, 'thursday': true, 'friday': true, 'saturday': false, 'sunday': false},
        'preferredLearningStyle': 'visual',
      },
      {
        'name': 'Aarav Sharma',
        'email': 'aarav@skillexchange.com',
        'password': 'Aarav1234@#\$',
        'role': 'user',
        'bio': 'Backend engineer specializing in Python and Django. Always looking to exchange knowledge.',
        'location': 'Bangalore, India',
        'timezone': 'UTC+5:30',
        'languages': ['English', 'Hindi'],
        'skillsToTeach': [
          {'name': 'Python', 'category': 'Programming', 'level': 'expert', 'isVerified': true},
          {'name': 'Django', 'category': 'Programming', 'level': 'advanced'},
          {'name': 'PostgreSQL', 'category': 'Programming', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'React', 'category': 'Programming', 'level': 'intermediate'},
          {'name': 'Cloud Architecture', 'category': 'Programming', 'level': 'beginner'},
        ],
        'interests': ['API Design', 'Open Source', 'Tech Talks'],
        'availability': {'monday': true, 'tuesday': false, 'wednesday': true, 'thursday': true, 'friday': false, 'saturday': true, 'sunday': false},
        'preferredLearningStyle': 'reading',
      },
      {
        'name': 'Diya Patel',
        'email': 'diya@skillexchange.com',
        'password': 'Diya1234@#\$',
        'role': 'user',
        'bio': 'UX designer with a passion for accessibility. I believe great design makes technology inclusive.',
        'location': 'Pune, India',
        'timezone': 'UTC+5:30',
        'languages': ['English', 'Hindi', 'Marathi'],
        'skillsToTeach': [
          {'name': 'Figma', 'category': 'Design', 'level': 'expert', 'isVerified': true},
          {'name': 'User Research', 'category': 'Design', 'level': 'advanced'},
          {'name': 'Prototyping', 'category': 'Design', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'Flutter', 'category': 'Programming', 'level': 'beginner'},
          {'name': 'Tailwind CSS', 'category': 'Programming', 'level': 'intermediate'},
        ],
        'interests': ['Design Systems', 'Accessibility', 'Photography'],
        'availability': {'monday': false, 'tuesday': true, 'wednesday': true, 'thursday': false, 'friday': true, 'saturday': true, 'sunday': false},
        'preferredLearningStyle': 'visual',
      },
      {
        'name': 'Rohan Verma',
        'email': 'rohan@skillexchange.com',
        'password': 'Rohan1234@#\$',
        'role': 'user',
        'bio': 'Full-stack JavaScript developer. Love building and shipping products.',
        'location': 'Delhi, India',
        'timezone': 'UTC+5:30',
        'languages': ['English', 'Hindi'],
        'skillsToTeach': [
          {'name': 'JavaScript', 'category': 'Programming', 'level': 'expert'},
          {'name': 'TypeScript', 'category': 'Programming', 'level': 'advanced'},
          {'name': 'Next.js', 'category': 'Programming', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'Rust', 'category': 'Programming', 'level': 'beginner'},
          {'name': 'System Design', 'category': 'Programming', 'level': 'intermediate'},
        ],
        'interests': ['Startups', 'Product Development', 'Gaming'],
        'availability': {'monday': true, 'tuesday': true, 'wednesday': true, 'thursday': true, 'friday': true, 'saturday': false, 'sunday': false},
        'preferredLearningStyle': 'kinesthetic',
      },
      {
        'name': 'Priya Nair',
        'email': 'priya@skillexchange.com',
        'password': 'Priya1234@#\$',
        'role': 'user',
        'bio': 'Data scientist who loves making sense of messy data. Teaching stats and ML fundamentals.',
        'location': 'Chennai, India',
        'timezone': 'UTC+5:30',
        'languages': ['English', 'Tamil', 'Malayalam'],
        'skillsToTeach': [
          {'name': 'Machine Learning', 'category': 'Science', 'level': 'expert', 'isVerified': true},
          {'name': 'Statistics', 'category': 'Science', 'level': 'advanced'},
          {'name': 'Python', 'category': 'Programming', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'Public Speaking', 'category': 'Business', 'level': 'beginner'},
          {'name': 'Technical Writing', 'category': 'Language', 'level': 'intermediate'},
        ],
        'interests': ['Data Viz', 'Research', 'Blogging'],
        'availability': {'monday': true, 'tuesday': true, 'wednesday': false, 'thursday': true, 'friday': true, 'saturday': true, 'sunday': false},
        'preferredLearningStyle': 'reading',
      },
      {
        'name': 'Arjun Mehta',
        'email': 'arjun@skillexchange.com',
        'password': 'Arjun1234@#\$',
        'role': 'user',
        'bio': 'DevOps engineer and photography enthusiast. Happy to teach cloud and learn creative arts.',
        'location': 'Hyderabad, India',
        'timezone': 'UTC+5:30',
        'languages': ['English', 'Hindi', 'Telugu'],
        'skillsToTeach': [
          {'name': 'AWS', 'category': 'Programming', 'level': 'expert'},
          {'name': 'Docker', 'category': 'Programming', 'level': 'advanced'},
          {'name': 'Photography', 'category': 'Design', 'level': 'intermediate'},
        ],
        'skillsToLearn': [
          {'name': 'Figma', 'category': 'Design', 'level': 'beginner'},
          {'name': 'Video Editing', 'category': 'Design', 'level': 'beginner'},
        ],
        'interests': ['Cloud Computing', 'Photography', 'Travel'],
        'availability': {'monday': false, 'tuesday': false, 'wednesday': true, 'thursday': true, 'friday': true, 'saturday': true, 'sunday': true},
        'preferredLearningStyle': 'auditory',
      },
      {
        'name': 'Sneha Joshi',
        'email': 'sneha@skillexchange.com',
        'password': 'Sneha1234@#\$',
        'role': 'user',
        'bio': 'Language teacher specializing in Hindi and Sanskrit. Also learning to code!',
        'location': 'Jaipur, India',
        'timezone': 'UTC+5:30',
        'languages': ['English', 'Hindi', 'Sanskrit'],
        'skillsToTeach': [
          {'name': 'Hindi', 'category': 'Language', 'level': 'expert', 'isVerified': true},
          {'name': 'Sanskrit', 'category': 'Language', 'level': 'advanced'},
          {'name': 'Content Writing', 'category': 'Language', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'Python', 'category': 'Programming', 'level': 'beginner'},
          {'name': 'Web Development', 'category': 'Programming', 'level': 'beginner'},
        ],
        'interests': ['Languages', 'Literature', 'Cultural Exchange'],
        'availability': {'monday': true, 'tuesday': true, 'wednesday': true, 'thursday': false, 'friday': false, 'saturday': true, 'sunday': true},
        'preferredLearningStyle': 'auditory',
      },
      {
        'name': 'Vikram Singh',
        'email': 'vikram@skillexchange.com',
        'password': 'Vikram1234@#\$',
        'role': 'user',
        'bio': 'Fitness trainer and nutrition coach. Believe in holistic health and wellness education.',
        'location': 'Ahmedabad, India',
        'timezone': 'UTC+5:30',
        'languages': ['English', 'Hindi', 'Gujarati'],
        'skillsToTeach': [
          {'name': 'Yoga', 'category': 'Other', 'level': 'expert'},
          {'name': 'Nutrition', 'category': 'Science', 'level': 'advanced'},
          {'name': 'Meditation', 'category': 'Other', 'level': 'intermediate'},
        ],
        'skillsToLearn': [
          {'name': 'Digital Marketing', 'category': 'Marketing', 'level': 'beginner'},
          {'name': 'App Development', 'category': 'Programming', 'level': 'beginner'},
        ],
        'interests': ['Fitness', 'Wellness', 'Nutrition Science'],
        'availability': {'monday': true, 'tuesday': true, 'wednesday': true, 'thursday': true, 'friday': true, 'saturday': false, 'sunday': false},
        'preferredLearningStyle': 'kinesthetic',
      },
      {
        'name': 'Ananya Krishnan',
        'email': 'ananya@skillexchange.com',
        'password': 'Ananya1234@#\$',
        'role': 'user',
        'bio': 'Mobile developer specializing in Flutter and Dart. Love building beautiful cross-platform apps.',
        'location': 'Kochi, India',
        'timezone': 'UTC+5:30',
        'languages': ['English', 'Malayalam', 'Hindi'],
        'skillsToTeach': [
          {'name': 'Flutter', 'category': 'Programming', 'level': 'expert', 'isVerified': true},
          {'name': 'Dart', 'category': 'Programming', 'level': 'expert'},
          {'name': 'Firebase', 'category': 'Programming', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'UI/UX Design', 'category': 'Design', 'level': 'intermediate'},
          {'name': 'Backend Development', 'category': 'Programming', 'level': 'intermediate'},
        ],
        'interests': ['Mobile Dev', 'Open Source', 'UI/UX'],
        'availability': {'monday': false, 'tuesday': true, 'wednesday': true, 'thursday': true, 'friday': false, 'saturday': true, 'sunday': true},
        'preferredLearningStyle': 'visual',
      },
      {
        'name': 'Rahul Gupta',
        'email': 'rahul@skillexchange.com',
        'password': 'Rahul1234@#\$',
        'role': 'user',
        'bio': 'Blockchain developer exploring Web3 and decentralized applications.',
        'location': 'Kolkata, India',
        'timezone': 'UTC+5:30',
        'languages': ['English', 'Hindi', 'Bengali'],
        'skillsToTeach': [
          {'name': 'Solidity', 'category': 'Programming', 'level': 'advanced'},
          {'name': 'Web3', 'category': 'Programming', 'level': 'advanced'},
          {'name': 'Smart Contracts', 'category': 'Programming', 'level': 'intermediate'},
        ],
        'skillsToLearn': [
          {'name': 'Machine Learning', 'category': 'Science', 'level': 'beginner'},
          {'name': 'React Native', 'category': 'Programming', 'level': 'intermediate'},
        ],
        'interests': ['Blockchain', 'DeFi', 'Crypto'],
        'availability': {'monday': true, 'tuesday': false, 'wednesday': true, 'thursday': false, 'friday': true, 'saturday': true, 'sunday': false},
        'preferredLearningStyle': 'reading',
      },
    ];

    final uids = <String>[];

    for (final userData in users) {
      try {
        // Create Firebase Auth user
        final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: userData['email'] as String,
          password: userData['password'] as String,
        );
        final uid = credential.user!.uid;
        uids.add(uid);

        final username = (userData['email'] as String).split('@').first;

        // Create user doc
        await _db.collection('users').doc(uid).set({
          'name': userData['name'],
          'email': userData['email'],
          'role': userData['role'],
          'isVerified': true,
          'isActive': true,
          'lastLogin': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Reserve username
        await _db.collection('usernames').doc(username).set({'uid': uid});

        // Create profile
        await _db.collection('profiles').doc(uid).set({
          'fullName': userData['name'],
          'username': username,
          'avatar': null,
          'coverImage': null,
          'bio': userData['bio'],
          'location': userData['location'],
          'timezone': userData['timezone'],
          'languages': userData['languages'],
          'skillsToTeach': userData['skillsToTeach'],
          'skillsToLearn': userData['skillsToLearn'],
          'interests': userData['interests'],
          'availability': userData['availability'],
          'preferredLearningStyle': userData['preferredLearningStyle'],
          'stats': {'connectionsCount': 0, 'sessionsCompleted': 0, 'reviewsReceived': 0, 'averageRating': 0.0},
          'privacyPreferences': {'profileVisibility': 'public', 'showEmail': false, 'showLocation': true, 'showOnlineStatus': true, 'allowMessages': 'everyone'},
          'notificationPreferences': {'emailNotifications': true, 'pushNotifications': true, 'connectionRequests': true, 'sessionReminders': true, 'newMessages': true, 'reviewsReceived': true, 'marketingEmails': false},
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Create matchPool
        await _db.collection('matchPool').doc(uid).set({
          'username': username,
          'avatar': null,
          'skillsToTeach': userData['skillsToTeach'],
          'skillsToLearn': userData['skillsToLearn'],
          'availability': userData['availability'],
          'location': userData['location'],
          'averageRating': 0.0,
          'sessionsCompleted': 0,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        debugPrint('Created user: ${userData['name']} ($uid)');
      } catch (e) {
        debugPrint('Failed to create ${userData['name']}: $e');
        uids.add(''); // placeholder
      }
    }

    // Sign out after creating all users (we were signed in as the last one)
    await FirebaseAuth.instance.signOut();

    // Create connections (using stored UIDs)
    if (uids.length >= 10) {
      final connectionPairs = [
        [0, 1], [0, 2], [0, 3], [0, 8], // Kruti connected to Aarav, Diya, Rohan, Ananya
        [1, 2], [1, 4], [1, 3], // Aarav connected to Diya, Priya, Rohan
        [2, 5], [3, 4], [4, 8], // Diya-Arjun, Rohan-Priya, Priya-Ananya
        [5, 6], [6, 7], [7, 8], // Arjun-Sneha, Sneha-Vikram, Vikram-Ananya
      ];

      for (final pair in connectionPairs) {
        if (uids[pair[0]].isEmpty || uids[pair[1]].isEmpty) continue;
        await _db.collection('connections').add({
          'requester': uids[pair[0]],
          'recipient': uids[pair[1]],
          'participants': [uids[pair[0]], uids[pair[1]]],
          'status': 'accepted',
          'message': '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Pending requests
      final pendingPairs = [[9, 0], [9, 4], [8, 9], [5, 9]];
      for (final pair in pendingPairs) {
        if (uids[pair[0]].isEmpty || uids[pair[1]].isEmpty) continue;
        await _db.collection('connections').add({
          'requester': uids[pair[0]],
          'recipient': uids[pair[1]],
          'participants': [uids[pair[0]], uids[pair[1]]],
          'status': 'pending',
          'message': 'Would love to connect and exchange skills!',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Community posts
      final posts = [
        {'author': uids[0], 'authorName': 'Kruti Manani', 'title': 'Welcome to Skill Exchange!', 'content': 'Excited to launch this platform! Share your skills, learn new ones, and grow together.', 'category': 'Announcements', 'tags': ['welcome', 'launch']},
        {'author': uids[1], 'authorName': 'Aarav Sharma', 'title': 'Python Tips for Beginners', 'content': 'Here are my top 5 tips for getting started with Python. Start with the basics and build projects early!', 'category': 'Teaching Tips', 'tags': ['python', 'beginners', 'tips']},
        {'author': uids[2], 'authorName': 'Diya Patel', 'title': 'Design System Resources', 'content': 'A curated list of the best design system resources for 2026. Figma, Sketch, and more.', 'category': 'Learning Resources', 'tags': ['design', 'resources', 'figma']},
        {'author': uids[4], 'authorName': 'Priya Nair', 'title': 'ML Project Ideas for Practice', 'content': 'Looking for ML project ideas? Here are 10 beginner-friendly projects to build your portfolio.', 'category': 'Learning Resources', 'tags': ['ml', 'projects', 'beginner']},
        {'author': uids[3], 'authorName': 'Rohan Verma', 'title': 'Looking for React Exchange Partner', 'content': 'I can teach JavaScript/TypeScript and want to learn Rust. Anyone interested in a weekly exchange?', 'category': 'Exchange Requests', 'tags': ['react', 'rust', 'exchange']},
        {'author': uids[8], 'authorName': 'Ananya Krishnan', 'title': 'Flutter vs React Native in 2026', 'content': 'My honest comparison after building apps in both frameworks this year.', 'category': 'Discussion', 'tags': ['flutter', 'react-native', 'comparison']},
      ];

      for (final post in posts) {
        await _db.collection('posts').add({
          ...post,
          'images': <Map<String, dynamic>>[],
          'videoUrl': null,
          'mediaType': 'text',
          'likesCount': 0,
          'repliesCount': 0,
          'likedBy': <String>[],
          'moderationStatus': 'active',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      // Learning circles
      final circles = [
        {'name': 'Python & Data Science Hub', 'description': 'A community for Python enthusiasts and data science learners.', 'category': 'Programming', 'createdBy': uids[1], 'members': [uids[1], uids[4], uids[0]]},
        {'name': 'Design & Dev Bridge', 'description': 'Bridging the gap between designers and developers.', 'category': 'Design', 'createdBy': uids[2], 'members': [uids[2], uids[0], uids[8]]},
        {'name': 'Language Exchange Circle', 'description': 'Practice languages with native speakers.', 'category': 'Language', 'createdBy': uids[6], 'members': [uids[6], uids[7]]},
        {'name': 'Web3 & Blockchain Explorers', 'description': 'Exploring the future of decentralized tech.', 'category': 'Programming', 'createdBy': uids[9], 'members': [uids[9], uids[3]]},
      ];

      for (final circle in circles) {
        await _db.collection('circles').add({
          ...circle,
          'maxMembers': 50,
          'imageUrl': null,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      debugPrint('\nSeed complete! Created ${uids.where((u) => u.isNotEmpty).length} users, connections, posts, and circles.');
    }
  }
}
