public with sharing class AccountService {

    public class AccountServiceException extends Exception {}

    public static Account createAccount(String accountName) {
        if (String.isBlank(accountName)) {
            throw new AccountServiceException(
                'Account name cannot be blank.'
            );
        }

        Account acc = new Account(
            Name = accountName.trim()
        );

        insert acc;

        return acc;
    }

    public static Account getAccount(Id accountId) {
        if (accountId == null) {
            throw new AccountServiceException(
                'Account Id cannot be null.'
            );
        }

        List<Account> accounts = [
            SELECT Id, Name
            FROM Account
            WHERE Id = :accountId
            LIMIT 1
        ];

        if (accounts.isEmpty()) {
            throw new AccountServiceException(
                'Account not found.'
            );
        }

        return accounts[0];
    }

    public static Boolean renameAccount(
        Id accountId,
        String newName
    ) {
        if (accountId == null || String.isBlank(newName)) {
            throw new AccountServiceException(
                'Account Id and new name are required.'
            );
        }

        Account acc = getAccount(accountId);
        acc.Name = newName.trim();
        update acc;

        return true;
    }
}