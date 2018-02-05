function EnableChangeTracking($EntityName){
      write-output "Finding entity: $EntityName"
      $entityRetrieve = new-object Microsoft.Xrm.Sdk.Messages.RetrieveEntityRequest
      $entityRetrieve.EntityFilters = 1
      $entityRetrieve.LogicalName = $EntityName
      $response = $conn.ExecuteCrmOrganizationRequest($entityRetrieve)
      write-output "Current value for ChangeTrackingEnabled on $EntityName is: $($response.EntityMetadata.ChangeTrackingEnabled)"
      $response.EntityMetadata.ChangeTrackingEnabled=$true
      $entityUpdate = new-object Microsoft.Xrm.Sdk.Messages.UpdateEntityRequest
      $entityUpdate.Entity = $response.EntityMetadata
      write-output "Setting ChangeTracking Enabled to: True on $EntityName"
      $response = $conn.ExecuteCrmOrganizationRequest($entityUpdate)
      if("" -ne $conn.LastCrmException)
      {
        throw $conn.LastCrmError    
      }    
}

function DisableChangeTracking($EntityName){
      write-output "Finding entity: $EntityName"
      $entityRetrieve = new-object Microsoft.Xrm.Sdk.Messages.RetrieveEntityRequest
      $entityRetrieve.EntityFilters = 1
      $entityRetrieve.LogicalName = $EntityName
      $response = $conn.ExecuteCrmOrganizationRequest($entityRetrieve)
      write-output "Current value for ChangeTrackingEnabled on $EntityName is: $($response.EntityMetadata.ChangeTrackingEnabled)"
      $response.EntityMetadata.ChangeTrackingEnabled=$false
      $entityUpdate = new-object Microsoft.Xrm.Sdk.Messages.UpdateEntityRequest
      $entityUpdate.Entity = $response.EntityMetadata
      write-output "Setting ChangeTracking Enabled to: False on $EntityName"
      $response = $conn.ExecuteCrmOrganizationRequest($entityUpdate)
      if("" -ne $conn.LastCrmException)
      {
        throw $conn.LastCrmError    
      } 
}
#enable change tracking on account, contact, and opportunity
"account,contact,opportunity".split(",")|foreach{EnableChangeTracking($_)}

#publish all metadata changes
$Publish = new-object Microsoft.Crm.Sdk.Messages.PublishAllXmlRequest
$conn.ExecuteCrmOrganizationRequest($Publish)
if("" -ne $conn.LastCrmException)
{
throw $conn.LastCrmError    
}    
