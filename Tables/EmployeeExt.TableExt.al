tableextension 50110 "EmployeeExt" extends Employee
{
    fields
    {
        field(50100; Rate; Decimal)
        {
            Caption = 'Rate';
            ObsoleteState = Pending;
            ObsoleteReason = 'Field will be removed in a future release';
            DataClassification = CustomerContent;
        }
        field(50101; TIN; Code[20])
        {
            Caption = 'TIN';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50102; SSS; Code[20])
        {
            Caption = 'SSS';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50103; PhilHealth; Code[20])
        {
            Caption = 'PhilHealth';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50104; PagIBIG; Code[20])
        {
            Caption = 'PagIBIG';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50105; BankAccountNo; Code[30])
        {
            Caption = 'Bank Account No.';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50106; BankName; Text[100])
        {
            Caption = 'Bank Name';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(50107; PayFrequency; Option)
        {
            Caption = 'Pay Frequency';
            OptionMembers = Monthly,"Semi-Monthly",Weekly,Daily,Project;
            OptionCaption = 'Monthly,Semi-Monthly,Weekly,Daily,Project-Based';
        }
    }
}