table 50100 "Employee Data"
{
    Caption = 'Employee Data';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; EmployeeId; Code[20])
        {
            Caption = 'EmployeeId';
        }
        field(2; EmployeeNo; Code[20])
        {
            Caption = 'EmployeeNo';
        }
        field(3; Position; Text[50])
        {
            Caption = 'Position';
        }
        field(4; Rate; Decimal)
        {
            Caption = 'Rate';
        }
        field(5; EffectivityDate; Date)
        {
            Caption = 'EffectivityDate';
        }
        field(6; TIN; Code[20])
        {
            Caption = 'TIN';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(7; SSS; Code[20])
        {
            Caption = 'SSS';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(8; PhilHealth; Code[20])
        {
            Caption = 'PhilHealth';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(9; PagIBIG; Code[20])
        {
            Caption = 'PagIBIG';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(10; BankAccountNo; Code[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(11; BankName; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(12; HireDate; Date)
        {
            Caption = 'Hire Date';
        }
        field(13; PayFrequency; Option)
        {
            Caption = 'Pay Frequency';
            OptionMembers = Monthly,"Semi-Monthly",Weekly,Daily;
            OptionCaption = 'Monthly,Semi-Monthly,Weekly,Daily';
        }
        field(14; PayType; Option)
        {
            Caption = 'Pay Type';
            OptionMembers = Salary,Hourly;
            OptionCaption = 'Salary,Hourly';
        }
        field(15; OvertimeRate; Decimal)
        {
            Caption = 'Overtime Rate';
            MinValue = 0;
            DecimalPlaces = 2;
        }
        field(16; HolidayRate; Decimal)
        {
            Caption = 'Holiday Rate';
            MinValue = 0;
            DecimalPlaces = 2;
        }
        field(17; FirstName; Text[50])
        {
            Caption = 'First Name';
            ObsoleteState = Pending;  // Optional: mark as obsolete if you don't plan to use them directly
            ObsoleteReason = 'Using standard Employee table for names';
        }
        field(18; LastName; Text[50])
        {
            Caption = 'Last Name';
            ObsoleteState = Pending;  // Optional: mark as obsolete if you don't plan to use them directly
            ObsoleteReason = 'Using standard Employee table for names';
        }
        field(19; BasicRate; Decimal)
        {
            Caption = 'Basic Rate';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field no longer needed';
            ObsoleteTag = '1.0.0.0';
        }
        field(20; AutoId; Integer)
        {
            Caption = 'Auto ID';
            ObsoleteState = Pending;
            AutoIncrement = true;
            ObsoleteReason = 'Field no longer needed';
            ObsoleteTag = '1.0.0.0';
        }
    }
    keys
    {
        key(PK; EmployeeId)
        {
            Clustered = true;
        }
    }
}
