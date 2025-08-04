page 50112 "Shift Assignment List"
{
    PageType = List;
    SourceTable = "Shift Assignment";
    Caption = 'Shift Assignment List';
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Shift Assignment No."; Rec."Shift Assignment No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift assignment number.';
                }
                field("Employee ID"; Rec."Employee ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee ID.';
                }
                field("Employee Name"; EmployeeName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the employee name.';
                    Editable = false;
                }
                field("Shift Code"; Rec."Shift Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift code.';
                }
                field("Shift Name"; ShiftName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the shift name.';
                    Editable = false;
                }
                field("Effective Date"; Rec."Effective Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the effective date.';
                }
                field("End Date"; Rec."End Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the end date.';
                }
                field("Is Active"; Rec."Is Active")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies if this assignment is active.';
                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the created date.';
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies who created this assignment.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(NewAssignment)
            {
                ApplicationArea = All;
                Caption = 'New Assignment';
                Image = New;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                ToolTip = 'Create a new shift assignment.';

                trigger OnAction()
                var
                    ShiftAssignment: Record "Shift Assignment";
                begin
                    ShiftAssignment.Init();
                    ShiftAssignment."Created Date" := Today;
                    ShiftAssignment."Created By" := UserId;
                    ShiftAssignment."Is Active" := true;
                    ShiftAssignment.Insert(true);
                end;
            }
            action(AutoAssignShift)
            {
                ApplicationArea = All;
                Caption = 'Auto Assign Shift';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Automatically assign shift codes based on employee data.';

                trigger OnAction()
                var
                    ShiftAssignment: Record "Shift Assignment";
                    EmployeeData: Record "Employee Data";
                    DefaultShift: Record Shift;
                    UpdatedCount: Integer;
                begin
                    UpdatedCount := 0;
                    if ShiftAssignment.FindSet() then
                        repeat
                            // Try to get employee's current shift from Employee Data
                            EmployeeData.Reset();
                            EmployeeData.SetRange(EmployeeId, ShiftAssignment."Employee ID");
                            if EmployeeData.FindFirst() then begin
                                // Look for a default shift (you can modify this logic)
                                DefaultShift.Reset();
                                DefaultShift.SetRange("Is Active", true);
                                if DefaultShift.FindFirst() then begin
                                    ShiftAssignment."Shift Code" := DefaultShift."Shift Code";
                                    ShiftAssignment.Modify();
                                    UpdatedCount += 1;
                                end;
                            end;
                        until ShiftAssignment.Next() = 0;

                    Message('Shift codes assigned to %1 assignments.', UpdatedCount);
                end;
            }
        }
    }

    var
        EmployeeName: Text;
        ShiftName: Text;

    trigger OnAfterGetRecord()
    var
        Employee: Record Employee;
        Shift: Record Shift;
    begin
        // Get employee name
        EmployeeName := '';
        if Employee.Get(Rec."Employee ID") then
            EmployeeName := Employee."First Name" + ' ' + Employee."Last Name";

        // Get shift name
        ShiftName := '';
        if Shift.Get(Rec."Shift Code") then
            ShiftName := Shift."Shift Name";
    end;
}