codeunit 50106 "Payroll Calculations"
{
    procedure CalculateSSS(GrossPay: Decimal; CurrentDate: Date): Decimal
    var
        SSSContribution: Record "SSS Contribution";
        SSSAmount: Decimal;
    begin
        // Default if no matching entry found
        SSSAmount := 0;

        // Try to find a matching bracket in the SSS Contribution table
        SSSContribution.Reset();
        SSSContribution.SetFilter("LowRate", '<=%1', GrossPay);
        SSSContribution.SetFilter("HighRate", '>=%1', GrossPay);
        SSSContribution.SetFilter("EffectiveDate", '<=%1', CurrentDate);
        SSSContribution.SetCurrentKey("EffectiveDate");
        SSSContribution.SetAscending("EffectiveDate", false); // Get the most recent applicable rate

        // Use the exact employee contribution amount from the table
        SSSAmount := SSSContribution.EmployeeShare;

        exit(SSSAmount);
    end;

    procedure CalculatePhilHealth(GrossPay: Decimal; CurrentDate: Date): Decimal
    var
        PhilHealthContribution: Record "PhilHealth Contribution";
        PhilHealthAmount: Decimal;
    begin
        // Default if no matching entry found
        PhilHealthAmount := 0;

        // Try to find a matching bracket in the PhilHealth contribution table
        PhilHealthContribution.Reset();
        PhilHealthContribution.SetFilter("MinSalary", '<=%1', GrossPay);
        PhilHealthContribution.SetFilter("MaxSalary", '>=%1', GrossPay);
        PhilHealthContribution.SetFilter("EffectiveDate", '<=%1', CurrentDate);
        PhilHealthContribution.SetCurrentKey("EffectiveDate");
        PhilHealthContribution.SetAscending("EffectiveDate", false); // Get the most recent applicable rate

        // Use the exact employee contribution amount from the table
        PhilHealthAmount := PhilHealthContribution.EmployeeShare;

        exit(PhilHealthAmount);
    end;
}