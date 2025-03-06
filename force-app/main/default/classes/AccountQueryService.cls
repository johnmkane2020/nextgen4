/**
 * @description AccountQueryService class handles all Account ID related queries
 * @author BuildAgent
 * @date 2025-03-05
 * @group Account Services
 * @version 1.0
 */
public with sharing class AccountQueryService {
    
    // Constants for error messages and limits
    private static final String ERROR_MSG_QUERY = 'Error occurred while querying accounts: ';
    private static final Integer DEFAULT_LIMIT = 50000;
    
    /**
     * @description Retrieves a list of Account records with Id field
     * @param recordLimit The maximum number of records to return
     * @return List<Account> List of Account records
     * @throws QueryException if there's an error executing the query
     */
    public List<Account> getAccountIds(Integer recordLimit) {
        try {
            // Validate and set the limit
            Integer limitToUse = (recordLimit != null && recordLimit > 0) 
                ? Math.min(recordLimit, DEFAULT_LIMIT) 
                : DEFAULT_LIMIT;
            
            // Execute query with security enforcement
            return [
                SELECT Id, Name 
                FROM Account 
                WITH SECURITY_ENFORCED 
                LIMIT :limitToUse
            ];
            
        } catch(QueryException qe) {
            handleError(ERROR_MSG_QUERY + qe.getMessage(), qe);
            throw new AccountQueryServiceException(ERROR_MSG_QUERY + qe.getMessage());
        } catch(Exception e) {
            handleError(ERROR_MSG_QUERY + e.getMessage(), e);
            throw new AccountQueryServiceException(ERROR_MSG_QUERY + e.getMessage());
        }
    }
    
    /**
     * @description Retrieves accounts based on a set of Account IDs
     * @param accountIds Set of Account IDs to query
     * @return List<Account> List of Account records
     * @throws QueryException if there's an error executing the query
     */
    public List<Account> getAccountsByIds(Set<Id> accountIds) {
        if(accountIds == null || accountIds.isEmpty()) {
            return new List<Account>();
        }
        
        try {
            return [
                SELECT Id, Name 
                FROM Account 
                WHERE Id IN :accountIds 
                WITH SECURITY_ENFORCED
            ];
            
        } catch(QueryException qe) {
            handleError(ERROR_MSG_QUERY + qe.getMessage(), qe);
            throw new AccountQueryServiceException(ERROR_MSG_QUERY + qe.getMessage());
        } catch(Exception e) {
            handleError(ERROR_MSG_QUERY + e.getMessage(), e);
            throw new AccountQueryServiceException(ERROR_MSG_QUERY + e.getMessage());
        }
    }
    
    /**
     * @description Retrieves accounts modified within the specified number of days
     * @param days Number of days to look back
     * @return List<Account> List of recently modified Account records
     */
    public List<Account> getRecentlyModifiedAccounts(Integer days) {
        if(days == null || days <= 0) {
            days = 30; // Default to 30 days if invalid input
        }
        
        try {
            DateTime cutoffDate = DateTime.now().addDays(-days);
            
            return [
                SELECT Id, Name, LastModifiedDate 
                FROM Account 
                WHERE LastModifiedDate >= :cutoffDate 
                WITH SECURITY_ENFORCED 
                LIMIT :DEFAULT_LIMIT
            ];
            
        } catch(QueryException qe) {
            handleError(ERROR_MSG_QUERY + qe.getMessage(), qe);
            throw new AccountQueryServiceException(ERROR_MSG_QUERY + qe.getMessage());
        } catch(Exception e) {
            handleError(ERROR_MSG_QUERY + e.getMessage(), e);
            throw new AccountQueryServiceException(ERROR_MSG_QUERY + e.getMessage());
        }
    }
    
    /**
     * @description Handles error logging and processing
     * @param errorMessage The error message to log
     * @param e The exception that was caught
     */
    private void handleError(String errorMessage, Exception e) {
        // Log the error
        System.debug(LoggingLevel.ERROR, errorMessage);
        System.debug(LoggingLevel.ERROR, 'Stack trace: ' + e.getStackTraceString());
        
        // Here you could add additional error handling like:
        // - Custom logging to a Log__c object
        // - Integration with monitoring services
        // - Email notifications for critical errors
    }
    
    /**
     * @description Custom exception class for AccountQueryService
     */
    public class AccountQueryServiceException extends Exception {}
}