@IsTest
private class AccountServiceTest {

    @TestSetup
    static void setupData() {
        insert new Account(Name = 'Deployment Test Account');
    }

    @IsTest
    static void testCreateAccountSuccess() {
        Test.startTest();

        Account result = AccountService.createAccount(
            '  New Test Account  '
        );

        Test.stopTest();

        System.assertNotEquals(null, result.Id);
        System.assertEquals('New Test Account', result.Name);
    }

    @IsTest
    static void testCreateAccountBlankName() {
        try {
            AccountService.createAccount(' ');
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AccountService.AccountServiceException ex) {
            System.assertEquals(
                'Account name cannot be blank.',
                ex.getMessage()
            );
        }
    }

    @IsTest
    static void testGetAccountSuccess() {
        Account existing = [
            SELECT Id, Name
            FROM Account
            WHERE Name = 'Deployment Test Account'
            LIMIT 1
        ];

        Test.startTest();

        Account result = AccountService.getAccount(existing.Id);

        Test.stopTest();

        System.assertEquals(existing.Id, result.Id);
        System.assertEquals(existing.Name, result.Name);
    }

    @IsTest
    static void testGetAccountNullId() {
        try {
            AccountService.getAccount(null);
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AccountService.AccountServiceException ex) {
            System.assertEquals(
                'Account Id cannot be null.',
                ex.getMessage()
            );
        }
    }

    @IsTest
    static void testGetAccountNotFound() {
        Account existing = [
            SELECT Id
            FROM Account
            WHERE Name = 'Deployment Test Account'
            LIMIT 1
        ];

        delete existing;

        Id deletedId = existing.Id;

        try {
            AccountService.getAccount(deletedId);
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AccountService.AccountServiceException ex) {
            System.assertEquals(
                'Account not found.',
                ex.getMessage()
            );
        }
    }

    @IsTest
    static void testRenameAccountSuccess() {
        Account existing = [
            SELECT Id
            FROM Account
            WHERE Name = 'Deployment Test Account'
            LIMIT 1
        ];

        Test.startTest();

        Boolean result = AccountService.renameAccount(
            existing.Id,
            'Renamed Test Account'
        );

        Test.stopTest();

        System.assertEquals(true, result);

        Account updatedAccount = [
            SELECT Name
            FROM Account
            WHERE Id = :existing.Id
        ];

        System.assertEquals(
            'Renamed Test Account',
            updatedAccount.Name
        );
    }

    @IsTest
    static void testRenameAccountNullId() {
        try {
            AccountService.renameAccount(null, 'Valid Name');
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AccountService.AccountServiceException ex) {
            System.assertEquals(
                'Account Id and new name are required.',
                ex.getMessage()
            );
        }
    }

    @IsTest
    static void testRenameAccountBlankName() {
        Account existing = [
            SELECT Id
            FROM Account
            WHERE Name = 'Deployment Test Account'
            LIMIT 1
        ];

        try {
            AccountService.renameAccount(existing.Id, ' ');
            System.assert(false, 'Expected exception was not thrown.');
        } catch (AccountService.AccountServiceException ex) {
            System.assertEquals(
                'Account Id and new name are required.',
                ex.getMessage()
            );
        }
    }
}