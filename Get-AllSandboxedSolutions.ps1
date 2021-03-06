param(
    [string]$SiteLimit = "ALL"
)
asnp *share*

# $webApplications = Get-SPWebApplication | ? { $_.DisplayName -ne "MySite Host" }
$webApplications = Get-SPWebApplication

foreach ($webApplication in $webApplications) {

    $memoryAssignment = Start-SPAssignment

    $allSites = Get-SPSite -WebApplication $webApplication -Limit $SiteLimit -Confirm:$false -AssignmentCollection $memoryAssignment
    foreach($site in $allSites)
    {
        #Write-Output "Checking Site " $site.Url " for solution " $SolutionName
        $solutions = Get-SPUserSolution -Site $site -AssignmentCollection $memoryAssignment
        foreach($solution in $solutions)
        {
            $output = New-Object -TypeName "System.Object"
            Add-Member -InputObject $output -MemberType NoteProperty -Name "SolutionName" -Value ""
            Add-Member -InputObject $output -MemberType NoteProperty -Name "SolutionId" -Value ""
            Add-Member -InputObject $output -MemberType NoteProperty -Name "SolutionStatus" -Value ""
            Add-Member -InputObject $output -MemberType NoteProperty -Name "SolutionHasAssemblies" -Value ""
            Add-Member -InputObject $output -MemberType NoteProperty -Name "SiteCollection" -Value ""
            $output.SolutionName = $solution.Name
            $output.SolutionId = $solution.SolutionId
            $output.SolutionStatus = $solution.Status
            $output.SolutionHasAssemblies = $solution.HasAssemblies
            $output.SiteCollection = $site.Url
            Write-Output -InputObject $output
            $numberOfSolutionsFound++
        }
    }
   
    Stop-SPAssignment $memoryAssignment
    
}



