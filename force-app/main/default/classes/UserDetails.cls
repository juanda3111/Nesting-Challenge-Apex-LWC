public with sharing class UserDetails {
    @AuraEnabled(cacheable=true)
    public static user getUserInfo(String userId) {
        return [SELECT ID, FirstName, LastName, Name, Title, Profile.Name,  Email From User WHERE ID =: userId LIMIT 1];
    }
}