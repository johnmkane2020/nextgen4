/**
 * @description Test class for AccountQueryService
 * @author BuildAgent
 * @version 1.0
 */
@IsTest
private class AccountQueryServiceTest {
    
    @TestSetup
    static void setupTestData() {
        // Create test accounts
        List<Account> testAccounts = new List<Account>();
        for(Integer i = 0; i < 10; i++) {
            testAccounts.add(new Account(
                Name = 'Test Account ' + i
            ));
        }
        insert testAccounts;
    }
    
    @IsTest
    static void testGetAccountIds() {
        // Arrange
        AccountQueryService service = new AccountQueryService();
        Integer limitCount = 5;
        
        // Act
        Test.startTest();
        List<Account> results = service.getAccountIds(limitCount);
        Test.stopTest();
        
        // Assert
        Assert.areEqual(limitCount, results.size(), 'Should return exactly 5 accounts');
        Assert.isNotNull(results[0].Id, 'Account ID should not be null');
    }
    
    @IsTest
    static void testGetAccountsByIds() {
        // Arrange
        AccountQueryService service = new AccountQueryService();
        Set<Id> accountIds = new Map<Id, Account>([SELECT Id FROM Account LIMIT 3]).keySet();
        
        // Act
        Test.startTest();
        List<Account> results = service.getAccountsByIds(accountIds);
        Test.stopTest();
        
        // Assert
        Assert.areEqual(accountIds.size(), results.size(), 'Should return all requested accounts');
    }
    
    @IsTest
    static void testGetRecentlyModifiedAccounts() {
        // Arrange
        AccountQueryService service = new AccountQueryService();
        
        // Act
        Test.startTest();
        List<Account> results = service.getRecentlyModifiedAccounts(7);
        Test.stopTest();
        
        // Assert
        Assert.isTrue(results.size() > 0, 'Should return recently modified accounts');
    }
    
    @IsTest
    static void testErrorHandling() {
        // Arrange
        AccountQueryService service = new AccountQueryService();
        
        // Act & Assert
        Test.startTest();
        try {
            service.getAccountsByIds(null);
            Assert.isTrue(true, 'Should handle null input gracefully');
        } catch(Exception e) {
            Assert.fail('Should not throw exception for null input');
        }
        Test.stopTest();
    }
}