codeunit 50105 "PhilHealth Import"
{
    trigger OnRun()
    begin
    end;

    procedure ImportPhilHealthTable()
    var
        TempExcelBuffer: Record "Excel Buffer" temporary;
        FileInStream: InStream;
        UploadResult: Boolean;
        FileName: Text;
        PhilHealthContribution: Record "PhilHealth Contribution";
    begin
        UploadResult := UploadIntoStream('Import PhilHealth Table', '', 'Excel Files (*.xlsx)|*.xlsx|All Files (*.*)|*.*',
                                        FileName, FileInStream);

        if not UploadResult then
            exit;

        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(FileInStream, 'PhilHealth Table');
        TempExcelBuffer.ReadSheet();

        if not ProcessExcelData(TempExcelBuffer, PhilHealthContribution) then
            Error('Failed to import PhilHealth Table. Please check the Excel format.');

        Message('PhilHealth Table has been imported successfully.');
    end;

    local procedure ProcessExcelData(var TempExcelBuffer: Record "Excel Buffer" temporary; var PhilHealthContribution: Record "PhilHealth Contribution"): Boolean
    var
        RowNo: Integer;
        MaxRowCount: Integer;
        EffectiveDate: Date;
    begin
        // Find the maximum row number
        TempExcelBuffer.SetCurrentKey("Row No.");
        if TempExcelBuffer.FindLast() then
            MaxRowCount := TempExcelBuffer."Row No.";

        // Ask for the effective date
        if not GetEffectiveDate(EffectiveDate) then
            exit(false);

        // Start from row 2 (assuming row 1 is header)
        for RowNo := 2 to MaxRowCount do begin
            if not ImportRow(TempExcelBuffer, RowNo, EffectiveDate, PhilHealthContribution) then
                exit(false);
        end;

        exit(true);
    end;

    local procedure ImportRow(var TempExcelBuffer: Record "Excel Buffer" temporary; RowNo: Integer;
                             EffectiveDate: Date; var PhilHealthContribution: Record "PhilHealth Contribution"): Boolean
    var
        MinSalary: Decimal;
        MaxSalary: Decimal;
        PremiumRate: Decimal;
        EmployeeShare: Decimal;
        EmployerShare: Decimal;
        TotalContribution: Decimal;
    begin
        // Read columns - adjust column numbers based on your Excel format
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 1, MinSalary) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 2, MaxSalary) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 3, PremiumRate) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 4, EmployeeShare) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 5, EmployerShare) then exit(false);
        if not GetDecimalCellValue(TempExcelBuffer, RowNo, 6, TotalContribution) then exit(false);

        // Create or update PhilHealth Contribution record
        PhilHealthContribution.Reset();
        PhilHealthContribution.SetRange("LowRate", MinSalary);
        PhilHealthContribution.SetRange("HighRate", MaxSalary);
        PhilHealthContribution.SetRange("EffectiveDate", EffectiveDate);

        if not PhilHealthContribution.FindFirst() then begin
            PhilHealthContribution.Init();
            PhilHealthContribution."LowRate" := MinSalary;
            PhilHealthContribution."HighRate" := MaxSalary;
            PhilHealthContribution."EffectiveDate" := EffectiveDate;
            PhilHealthContribution.Insert();
        end;

        PhilHealthContribution."PremiumRate" := PremiumRate;
        PhilHealthContribution."EmployeeShare" := EmployeeShare;
        PhilHealthContribution."EmployerShare" := EmployerShare;
        PhilHealthContribution.Modify();

        exit(true);
    end;

    local procedure GetDecimalCellValue(var TempExcelBuffer: Record "Excel Buffer" temporary;
                                       RowNo: Integer; ColNo: Integer; var Value: Decimal): Boolean
    begin
        TempExcelBuffer.Reset();
        TempExcelBuffer.SetRange("Row No.", RowNo);
        TempExcelBuffer.SetRange("Column No.", ColNo);

        if not TempExcelBuffer.FindFirst() then
            exit(false);

        // Excel buffer stores numbers as text, so we need to evaluate it
        Evaluate(Value, TempExcelBuffer."Cell Value as Text");
        exit(true);
    end;

    local procedure GetEffectiveDate(var EffectiveDate: Date): Boolean
    var
        DateText: Text;
        ConfirmManagement: Codeunit "Confirm Management";
    begin
        DateText := Format(Today, 0, '<Day,2>/<Month,2>/<Year4>');

        if ConfirmManagement.GetResponseOrDefault('Enter effective date (DD/MM/YYYY): ' + DateText, true) then begin
            Evaluate(EffectiveDate, DateText);
            exit(true);
        end;

        exit(false);
    end;
}