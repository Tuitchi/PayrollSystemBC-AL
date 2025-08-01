table 50103 "SSS Contribution"
{
    DataClassification = ToBeClassified;
    Caption = 'SSS Contribution Table';

    fields
    {
        field(1; "LowRate"; Decimal) { Caption = 'Low Rate'; }
        field(2; "HighRate"; Decimal) { Caption = 'High Rate'; }
        field(3; "MSC"; Decimal) { Caption = 'Monthly Salary Credit'; }
        field(4; "EmployeeShare"; Decimal) { Caption = 'Employee Share'; }
        field(5; "EmployerShare"; Decimal) { Caption = 'Employer Share'; }
        field(6; "ECC"; Decimal) { Caption = 'Employer EC Contribution'; }
        field(7; "TotalContribution"; Decimal) { Caption = 'Total Contribution'; }
        field(8; "EffectiveDate"; Date) { Caption = 'Effective Date'; DataClassification = OrganizationIdentifiableInformation; }

    }

    keys
    {
        key(PK; "LowRate", "HighRate", "EffectiveDate") { Clustered = true; }
    }
}