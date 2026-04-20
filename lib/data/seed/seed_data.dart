import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class SeedData {
  static final _db = FirebaseFirestore.instance;

  static Future<void> seed() async {
    final users = [
      {
        'name': 'Kruti Manani',
        'email': 'Kmanani465@rku.ac.in',
        'password': 'Kruti1234@#\$',
        'role': 'admin',
        'bio': 'Platform admin and full-stack developer. Passionate about education technology and skill sharing.',
        'location': 'Rajkot, Gujarat',
        'timezone': 'Asia/Kolkata',
        'languages': ['Gujarati', 'Hindi', 'English'],
        'coverImage': 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?w=1200&h=400&fit=crop',
        'skillsToTeach': [
          {'name': 'React', 'category': 'Programming', 'level': 'expert', 'isVerified': true},
          {'name': 'Node.js', 'category': 'Programming', 'level': 'expert', 'isVerified': true},
          {'name': 'UI/UX Design', 'category': 'Design', 'level': 'advanced', 'isVerified': true},
        ],
        'skillsToLearn': [
          {'name': 'Machine Learning', 'category': 'Data Science', 'level': 'beginner'},
          {'name': 'DevOps', 'category': 'Programming', 'level': 'intermediate'},
        ],
        'interests': ['EdTech', 'Open Source', 'UI Design'],
        'availability': {'monday': true, 'tuesday': true, 'wednesday': true, 'thursday': true, 'friday': true, 'saturday': false, 'sunday': false},
        'preferredLearningStyle': 'visual',
      },
      {
        'name': 'Aarav Sharma',
        'email': 'aarav.sharma@example.com',
        'password': 'Aarav1234@#\$',
        'role': 'user',
        'bio': 'Backend engineer with 4 years of experience. Love teaching Python and learning design.',
        'location': 'Mumbai, Maharashtra',
        'timezone': 'Asia/Kolkata',
        'languages': ['Hindi', 'English', 'Marathi'],
        'coverImage': 'https://images.unsplash.com/photo-1555066931-4365d14bab8c?w=1200&h=400&fit=crop',
        'skillsToTeach': [
          {'name': 'Python', 'category': 'Programming', 'level': 'expert', 'isVerified': true},
          {'name': 'Django', 'category': 'Programming', 'level': 'advanced'},
          {'name': 'SQL', 'category': 'Database', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'Figma', 'category': 'Design', 'level': 'beginner'},
          {'name': 'React', 'category': 'Programming', 'level': 'intermediate'},
        ],
        'interests': ['Backend Development', 'Open Source', 'Chess'],
        'availability': {'monday': true, 'tuesday': false, 'wednesday': true, 'thursday': false, 'friday': true, 'saturday': true, 'sunday': false},
        'preferredLearningStyle': 'reading',
      },
      {
        'name': 'Diya Patel',
        'email': 'diya.patel@example.com',
        'password': 'Diya1234@#\$',
        'role': 'user',
        'bio': 'Graphic designer turned UX specialist. I love making things look beautiful and usable.',
        'location': 'Ahmedabad, Gujarat',
        'timezone': 'Asia/Kolkata',
        'languages': ['Gujarati', 'Hindi', 'English'],
        'coverImage': 'https://images.unsplash.com/photo-1561070791-2526d30994b5?w=1200&h=400&fit=crop',
        'skillsToTeach': [
          {'name': 'Figma', 'category': 'Design', 'level': 'expert', 'isVerified': true},
          {'name': 'Adobe Illustrator', 'category': 'Design', 'level': 'advanced'},
          {'name': 'UI Design', 'category': 'Design', 'level': 'expert'},
        ],
        'skillsToLearn': [
          {'name': 'Python', 'category': 'Programming', 'level': 'beginner'},
          {'name': 'JavaScript', 'category': 'Programming', 'level': 'beginner'},
        ],
        'interests': ['Typography', 'Color Theory', 'Motion Design'],
        'availability': {'monday': false, 'tuesday': true, 'wednesday': false, 'thursday': true, 'friday': false, 'saturday': true, 'sunday': true},
        'preferredLearningStyle': 'visual',
      },
      {
        'name': 'Rohan Verma',
        'email': 'rohan.verma@example.com',
        'password': 'Rohan1234@#\$',
        'role': 'user',
        'bio': 'Full-stack developer at a startup. Teaching JavaScript and learning classical music in my spare time.',
        'location': 'Bangalore, Karnataka',
        'timezone': 'Asia/Kolkata',
        'languages': ['Hindi', 'English', 'Kannada'],
        'coverImage': null,
        'skillsToTeach': [
          {'name': 'JavaScript', 'category': 'Programming', 'level': 'expert'},
          {'name': 'React', 'category': 'Programming', 'level': 'advanced'},
          {'name': 'TypeScript', 'category': 'Programming', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'Hindustani Classical Music', 'category': 'Music', 'level': 'beginner'},
          {'name': 'Tabla', 'category': 'Music', 'level': 'beginner'},
        ],
        'interests': ['Web Dev', 'Music', 'Gaming'],
        'availability': {'monday': true, 'tuesday': true, 'wednesday': false, 'thursday': true, 'friday': false, 'saturday': false, 'sunday': true},
        'preferredLearningStyle': 'kinesthetic',
      },
      {
        'name': 'Priya Nair',
        'email': 'priya.nair@example.com',
        'password': 'Priya1234@#\$',
        'role': 'user',
        'bio': 'Data scientist who loves cooking. I teach machine learning and Bharatanatyam dance.',
        'location': 'Kochi, Kerala',
        'timezone': 'Asia/Kolkata',
        'languages': ['Malayalam', 'Hindi', 'English'],
        'coverImage': null,
        'skillsToTeach': [
          {'name': 'Machine Learning', 'category': 'Data Science', 'level': 'expert', 'isVerified': true},
          {'name': 'Data Analysis', 'category': 'Data Science', 'level': 'advanced'},
          {'name': 'Bharatanatyam', 'category': 'Dance', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'Node.js', 'category': 'Programming', 'level': 'intermediate'},
          {'name': 'DevOps', 'category': 'Programming', 'level': 'beginner'},
        ],
        'interests': ['Data Science', 'Classical Dance', 'Cooking'],
        'availability': {'monday': false, 'tuesday': true, 'wednesday': true, 'thursday': false, 'friday': true, 'saturday': true, 'sunday': false},
        'preferredLearningStyle': 'reading',
      },
      {
        'name': 'Arjun Mehta',
        'email': 'arjun.mehta@example.com',
        'password': 'Arjun1234@#\$',
        'role': 'user',
        'bio': 'DevOps engineer and photographer. Happy to teach cloud infrastructure and Lightroom editing.',
        'location': 'Pune, Maharashtra',
        'timezone': 'Asia/Kolkata',
        'languages': ['Hindi', 'English', 'Marathi'],
        'coverImage': null,
        'skillsToTeach': [
          {'name': 'DevOps', 'category': 'Programming', 'level': 'expert'},
          {'name': 'AWS', 'category': 'Cloud', 'level': 'advanced'},
          {'name': 'Photography', 'category': 'Creative', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'Machine Learning', 'category': 'Data Science', 'level': 'intermediate'},
          {'name': 'Figma', 'category': 'Design', 'level': 'beginner'},
        ],
        'interests': ['Cloud Computing', 'Photography', 'Hiking'],
        'availability': {'monday': true, 'tuesday': false, 'wednesday': true, 'thursday': true, 'friday': false, 'saturday': true, 'sunday': true},
        'preferredLearningStyle': 'auditory',
      },
      {
        'name': 'Sneha Joshi',
        'email': 'sneha.joshi@example.com',
        'password': 'Sneha1234@#\$',
        'role': 'user',
        'bio': 'Hindi and Sanskrit teacher, also passionate about web development. Language learning is my superpower.',
        'location': 'Jaipur, Rajasthan',
        'timezone': 'Asia/Kolkata',
        'languages': ['Hindi', 'Sanskrit', 'English', 'Rajasthani'],
        'coverImage': null,
        'skillsToTeach': [
          {'name': 'Hindi', 'category': 'Language', 'level': 'expert'},
          {'name': 'Sanskrit', 'category': 'Language', 'level': 'expert'},
          {'name': 'Content Writing', 'category': 'Writing', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'React', 'category': 'Programming', 'level': 'beginner'},
          {'name': 'JavaScript', 'category': 'Programming', 'level': 'beginner'},
        ],
        'interests': ['Languages', 'Literature', 'Yoga'],
        'availability': {'monday': true, 'tuesday': true, 'wednesday': true, 'thursday': false, 'friday': false, 'saturday': true, 'sunday': false},
        'preferredLearningStyle': 'auditory',
      },
      {
        'name': 'Vikram Singh',
        'email': 'vikram.singh@example.com',
        'password': 'Vikram1234@#\$',
        'role': 'user',
        'bio': 'Fitness trainer and nutrition coach. Teaching others to be healthy while I learn digital marketing.',
        'location': 'Delhi, NCR',
        'timezone': 'Asia/Kolkata',
        'languages': ['Hindi', 'Punjabi', 'English'],
        'coverImage': null,
        'skillsToTeach': [
          {'name': 'Fitness Training', 'category': 'Health & Fitness', 'level': 'expert'},
          {'name': 'Nutrition', 'category': 'Health & Fitness', 'level': 'advanced'},
          {'name': 'Yoga', 'category': 'Health & Fitness', 'level': 'intermediate'},
        ],
        'skillsToLearn': [
          {'name': 'Digital Marketing', 'category': 'Marketing', 'level': 'beginner'},
          {'name': 'Video Editing', 'category': 'Creative', 'level': 'beginner'},
        ],
        'interests': ['Fitness', 'Sports', 'Nutrition Science'],
        'availability': {'monday': true, 'tuesday': true, 'wednesday': true, 'thursday': true, 'friday': true, 'saturday': false, 'sunday': false},
        'preferredLearningStyle': 'kinesthetic',
      },
      {
        'name': 'Ananya Krishnan',
        'email': 'ananya.krishnan@example.com',
        'password': 'Ananya1234@#\$',
        'role': 'user',
        'bio': 'Mobile app developer specialising in Flutter. I also teach Carnatic music on weekends.',
        'location': 'Chennai, Tamil Nadu',
        'timezone': 'Asia/Kolkata',
        'languages': ['Tamil', 'English', 'Telugu'],
        'coverImage': null,
        'skillsToTeach': [
          {'name': 'Flutter', 'category': 'Programming', 'level': 'expert'},
          {'name': 'Dart', 'category': 'Programming', 'level': 'advanced'},
          {'name': 'Carnatic Music', 'category': 'Music', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'Python', 'category': 'Programming', 'level': 'intermediate'},
          {'name': 'Data Analysis', 'category': 'Data Science', 'level': 'beginner'},
        ],
        'interests': ['Mobile Dev', 'Classical Music', 'Reading'],
        'availability': {'monday': false, 'tuesday': true, 'wednesday': true, 'thursday': false, 'friday': true, 'saturday': true, 'sunday': true},
        'preferredLearningStyle': 'visual',
      },
      {
        'name': 'Rahul Gupta',
        'email': 'rahul.gupta@example.com',
        'password': 'Rahul1234@#\$',
        'role': 'user',
        'bio': 'Blockchain developer and chess enthusiast. Open to teaching smart contracts and learning digital art.',
        'location': 'Hyderabad, Telangana',
        'timezone': 'Asia/Kolkata',
        'languages': ['Hindi', 'Telugu', 'English'],
        'coverImage': null,
        'skillsToTeach': [
          {'name': 'Blockchain', 'category': 'Programming', 'level': 'expert'},
          {'name': 'Solidity', 'category': 'Programming', 'level': 'advanced'},
          {'name': 'Chess', 'category': 'Sports & Games', 'level': 'advanced'},
        ],
        'skillsToLearn': [
          {'name': 'Digital Art', 'category': 'Creative', 'level': 'beginner'},
          {'name': 'Figma', 'category': 'Design', 'level': 'beginner'},
        ],
        'interests': ['Web3', 'Chess', 'Philosophy'],
        'availability': {'monday': true, 'tuesday': false, 'wednesday': false, 'thursday': true, 'friday': true, 'saturday': true, 'sunday': false},
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
          'coverImage': userData['coverImage'],
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
        // If user already exists, sign in to get UID
        if (e.toString().contains('email-already-in-use')) {
          try {
            final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: userData['email'] as String,
              password: userData['password'] as String,
            );
            final uid = credential.user!.uid;
            uids.add(uid);

            // Update profile and matchPool data (re-seed)
            await _db.collection('profiles').doc(uid).set({
              'fullName': userData['name'],
              'username': (userData['email'] as String).split('@').first.toLowerCase(),
              'avatar': null,
              'coverImage': userData['coverImage'],
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
            }, SetOptions(merge: true));

            await _db.collection('matchPool').doc(uid).set({
              'username': (userData['email'] as String).split('@').first.toLowerCase(),
              'avatar': null,
              'skillsToTeach': userData['skillsToTeach'],
              'skillsToLearn': userData['skillsToLearn'],
              'availability': userData['availability'],
              'location': userData['location'],
              'averageRating': 0.0,
              'sessionsCompleted': 0,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            await _db.collection('users').doc(uid).set({
              'name': userData['name'],
              'email': userData['email'],
              'role': userData['role'],
              'isVerified': true,
              'isActive': true,
              'updatedAt': FieldValue.serverTimestamp(),
            }, SetOptions(merge: true));

            debugPrint('Re-seeded existing user: ${userData['name']} ($uid)');
            continue;
          } catch (signInError) {
            debugPrint('Failed to re-seed ${userData['name']}: $signInError');
            uids.add('');
          }
        } else {
          debugPrint('Failed to create ${userData['name']}: $e');
          uids.add('');
        }
      }
    }

    // Sign in as the admin user (first user) to create connections/posts/circles
    // because Firestore rules require authentication for writes.
    if (uids.isNotEmpty && uids[0].isNotEmpty) {
      await FirebaseAuth.instance.signOut();
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: users[0]['email'] as String,
        password: users[0]['password'] as String,
      );
      debugPrint('Signed in as admin to create seed data...');
    }

    // Clean up existing seed data before re-creating
    debugPrint('Cleaning up existing connections, posts, circles...');
    final existingConns = await _db.collection('connections').get();
    for (final doc in existingConns.docs) {
      await doc.reference.delete();
    }
    final existingPosts = await _db.collection('posts').get();
    for (final doc in existingPosts.docs) {
      await doc.reference.delete();
    }
    final existingCircles = await _db.collection('circles').get();
    for (final doc in existingCircles.docs) {
      await doc.reference.delete();
    }
    debugPrint('Cleanup done.');

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
        {'author': uids[3], 'authorName': 'Rohan Verma', 'title': 'Looking for React Exchange Partner', 'content': 'I can teach JavaScript/TypeScript and want to learn classical music. Anyone interested in a weekly exchange?', 'category': 'Exchange Requests', 'tags': ['react', 'music', 'exchange']},
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

      // Update connection counts in profiles
      final connectionCount = <String, int>{};
      for (final pair in connectionPairs) {
        final u1 = uids[pair[0]];
        final u2 = uids[pair[1]];
        if (u1.isEmpty || u2.isEmpty) continue;
        connectionCount[u1] = (connectionCount[u1] ?? 0) + 1;
        connectionCount[u2] = (connectionCount[u2] ?? 0) + 1;
      }
      for (final entry in connectionCount.entries) {
        await _db.collection('profiles').doc(entry.key).update({
          'stats.connectionsCount': entry.value,
        });
      }

      debugPrint('\nSeed complete! Created ${uids.where((u) => u.isNotEmpty).length} users, connections, posts, and circles.');
    }

    // Sign out at the very end
    await FirebaseAuth.instance.signOut();
  }
}
