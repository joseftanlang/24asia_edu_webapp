class UserModel {
  final String uid;
  final String email;
  final String fullName;
  final String role;

  final String status;

  final bool profileCompleted;

  final String dob;
  final String bloodGroup;
  final String mobile;
  final String company;
  final String jobTitle;
  final String photoUrl;

  UserModel({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    required this.status,
    required this.profileCompleted,
    required this.dob,
    required this.bloodGroup,
    required this.mobile,
    required this.company,
    required this.jobTitle,
    required this.photoUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      role: map['role'] ?? '',
      status: map['status'] ?? '',
      profileCompleted: map['profileCompleted'] ?? false,
      dob: map['dob'] ?? '',
      bloodGroup: map['bloodGroup'] ?? '',
      mobile: map['mobile'] ?? '',
      company: map['company'] ?? '',
      jobTitle: map['jobTitle'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'role': role,
      'status': status,
      'profileCompleted': profileCompleted,
      'dob': dob,
      'bloodGroup': bloodGroup,
      'mobile': mobile,
      'company': company,
      'jobTitle': jobTitle,
      'photoUrl': photoUrl,
    };
  }
}