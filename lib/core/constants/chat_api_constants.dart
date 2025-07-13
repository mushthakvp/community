class ChatApiConstants {
  // Base URLs
  static const String chatBaseUrlPro = 'https://chat.prod.liveraapp.com/chat/';
  static const String chatBaseUrlDev = 'http://192.168.3.6:3555/chat/';
  static const String chatBaseUrl = 'http://192.168.3.6:3555/chat/';
  static const String chatSocketUrl = 'http://192.168.3.6:3555/';

  // Chat Module Endpoints

  // Community Operations
  static const String getRecommendCommunity = 'getCommunities';
  static const String getMyGroupData = 'listHomeData';
  static const String createCommunity = 'createCommunity';
  static const String enterChat = 'communityOpen/';
  static const String editCommunity = 'editCommunity/';
  static const String getCommunityMembers = 'communityMembers/';
  static const String getCommunityMemberRequest = 'listJoinRequests/';
  static const String approveMemberRequest = 'approveJoinRequest/';
  static const String rejectMemberRequest = 'declineJoinRequest/';
  static const String joinCommunity = 'joinCommunity/';
  static const String leftCommunity = 'leftCommunity/';
  static const String removeFromCommunity = 'removeMember/';
  static const String deleteCommunity = 'deleteGroup/';
  static const String addFriendToCommunity = 'addMember/';

  // Friend Operations
  static const String acceptFriendRequest = 'acceptRequest/';
  static const String rejectFriendRequest = 'rejectRequest/';
  static const String sendFriendRequest = 'sendRequest/';
  static const String removeFriend = 'removeFriend/';

  // Message Operations
  static const String fetchAllMessagesSingleChat = 'fetchChats';
  static const String sendMessage = 'sendMessage';
  static const String getAllChatLit = 'fetchChats';
  static const String accessChatUrl = 'accessChat';
  static const String getSingleChat = 'accessChat';

  // Birthday Wishes
  static const String getTodaysBirthdayFriends = 'getTodaysBirthdayFriends/';
  static const String sentBirthdayWishes = 'sendBirthdayWish';

  // Wallpaper Operations
  static const String getWallpaper = 'getWallpapers';
  static const String setSingleChatWallpaper = 'setSingleChatWallpaper';
  static const String setGroupWallpaper = 'setGroupWallpapers';

  // Other endpoints from the original code for reference
  static const String getCoupons = 'user/getCoupons';
  static const String actionOnCoupons = 'user/actionOnCoupon/';
  static const String useCoupon = 'user/useCoupon/';
}
