PIPELINE_JSON=$(aws ssm get-parameter --output json --name /pipeline_manager/pipelines_parameters/pipelines) 
echo "$PIPELINE_JSON" | jq -r '.Parameter.Value | fromjson | .[]' -c | while read -r item; do
    
    # Now '$item' contains the entire single-line JSON string for this iteration.
    # You can safely extract individual properties like this:
    NAME=$(echo "$item" | jq -r '.name')
    REPO=$(echo "$item" | jq -r '.repo_path')
    
    echo "Processing Name: $NAME"
    echo "Processing Repo: $REPO"
    echo "------------------------"
    # Start a separate worker build programmatically
          aws codebuild start-build \
            --project-name "My-Worker-Project" \
            --environment-variables-override name=DEPLOY_TARGET,value=$env_item,type=PLAINTEXT &
    
done
