table 50104 "PhilHealth Contribution"
{
    DataClassification = ToBeClassified;
    Caption = 'PhilHealth Contribution Table';

    fields
    {
        field(1; "MinSalary"; Decimal) { Caption = 'Minimum Monthly Basic Salary'; }
        field(2; "MaxSalary"; Decimal) { Caption = 'Maximum Monthly Basic Salary'; }
        field(3; "PremiumRate"; Decimal) { Caption = 'Premium Rate (%)'; }
        field(4; "EmployeeShare"; Decimal) { Caption = 'Employee Share'; }
        field(5; "EmployerShare"; Decimal) { Caption = 'Employer Share'; }
        field(6; "TotalContribution"; Decimal) { Caption = 'Total Contribution'; }
        field(7; "EffectiveDate"; Date) { Caption = 'Effective Date'; DataClassification = OrganizationIdentifiableInformation; }
    }

    keys
    {
        key(PK; "MinSalary", "MaxSalary", "EffectiveDate") { Clustered = true; }
    }
}