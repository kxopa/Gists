
Function Get_thumbprint {

  Param ([String]$path,[String]$thumbprint_samples)
  
  if ($path -and $thumbprint_samples){
  
  	 $exists_path = Test-Path $path
	 $exists_file = Test-Path $thumbprint_samples
  	 	 
	 if($exists_path -and $exists_file){
	 
		  foreach($item in Get-ChildItem -Force $path -Recurse){		
				
				if($item.extension -eq ".exe"){	  
					
					Try{
					
					  Write-Progress -CurrentOperation "`r"$path$item"              ........"
					  $result = get-AuthenticodeSignature -filepath $item.fullname
					  
					  if($result.SignerCertificate.Thumbprint -ne $null){
						  if(Select-String $thumbprint_samples -pattern $result.SignerCertificate.Thumbprint){

							Write-Host  "`r$item Thumbprint: " $result.SignerCertificate.Thumbprint"`r" 
						  }
					   }
					  
					  }
					
					Catch{
					
						$ErrorMessage = $_.Exception.Message
					    Write-Host "Error reading file" $item. "The error message was" $ErrorMessage -foregroundcolor red

						}
											  
				}
		   }
	  	
			 Write-Host "`nAll Done."
	  }else{
	  	Write-Host "Error. Check parameters."
  		}
	}else{
		Write-Host "Error. Check parameters."
		Write-Host "Usage: get_thumbprint <signed_path> <thumbprints_path_file>"
		}
}