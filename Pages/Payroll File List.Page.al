page 50113 "Payroll File List"
{
    PageType = List;
    SourceTable = "Payroll File";
    Caption = 'Payroll File List';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Payroll File ID"; Rec."Payroll File ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payroll file ID.';
                }
                field("Department ID"; Rec."Department ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department ID.';
                }
                field("Department Name"; DepartmentName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the department name.';
                    Editable = false;
                }
                field("Payroll Period Start"; Rec."Payroll Period Start")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payroll period start date.';
                }
                field("Payroll Period End"; Rec."Payroll Period End")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the payroll period end date.';
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description.';
                }
                field("Status"; Rec."Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the status of the payroll file.';
                }
                field("Total Employees"; Rec."Total Employees")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the total number of employees in this payroll file.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the created date.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who created this payroll file.';
                }
                field("System ID"; Rec."System ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the system ID.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewPayrollFile)
            {
                ApplicationArea = All;
                Caption = 'New Payroll File';
                Image = New;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ToolTip = 'Create a new payroll file.';

                trigger OnAction()
                var
                    PayrollFileCard: Page "Payroll File Card";
                begin
                    PayrollFileCard.RunModal();
                end;
            }
            action(ProcessPayroll)
            {
                ApplicationArea = All;
                Caption = 'Process Payroll';
                Image = Process;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Process the selected payroll file.';

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Draft then begin
                        Rec.Status := Rec.Status::Processing;
                        Rec.Modify();
                        Message('Payroll file %1 is now being processed.', Rec."Payroll File ID");
                    end else
                        Error('Only draft payroll files can be processed.');
                end;
            }
            action(CompletePayroll)
            {
                ApplicationArea = All;
                Caption = 'Complete Payroll';
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Mark the payroll file as completed.';

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Processing then begin
                        Rec.Status := Rec.Status::Completed;
                        Rec.Modify();
                        Message('Payroll file %1 has been completed.', Rec."Payroll File ID");
                    end else
                        Error('Only processing payroll files can be completed.');
                end;
            }
            action(CalculateTotals)
            {
                ApplicationArea = All;
                Caption = 'Calculate Totals';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Calculate totals for this payroll file.';

                trigger OnAction()
                var
                    PayrollTransaction: Record "Payroll Transaction";
                    EmployeeCount: Integer;
                    TotalGross: Decimal;
                    TotalNet: Decimal;
                begin
                    // Calculate totals from Payroll Transaction table
                    PayrollTransaction.Reset();
                    PayrollTransaction.SetRange("Payroll Period ID", Rec."Payroll File ID");

                    EmployeeCount := PayrollTransaction.Count();

                    Rec."Total Employees" := EmployeeCount;
                    Rec.Modify();

                    Message('Totals calculated: %1 employees, Gross: %2, Net: %3',
                        EmployeeCount, TotalGross, TotalNet);
                end;
            }
        }
    }

    var
        DepartmentName: Text;

    trigger OnAfterGetRecord()
    var
        DimensionValue: Record "Dimension Value";
    begin
        // Get department name
        DepartmentName := '';
        DimensionValue.Reset();
        DimensionValue.SetRange("Dimension Code", 'DEPARTMENT');
        DimensionValue.SetRange(Code, Rec."Department ID");
        if DimensionValue.FindFirst() then
            DepartmentName := DimensionValue.Name;
    end;
}