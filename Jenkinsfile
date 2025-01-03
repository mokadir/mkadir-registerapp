pipeline {
	agent {							
        label "buildAgent"	
    }
	
	tools {
		maven 'maven3'			
	}
	
	stages {
		stage ('Clean Workspace'){
			steps {
                echo "****** Workspace Cleanup running....******"
				cleanWs()
			}
		}
	
		stage ('Git Checkout'){
			steps {
                echo "****** Git Checkout running....******"
				git branch: 'dev', credentialsId: 'git-cred', url: 'https://github.com/mokadir/mkadirbank.git'
			}
		}
		
		stage ('Compile'){
			steps {
                echo "****** Compile running....******"
				sh "mvn compile"
			}
		}
		
		stage ('Build Application'){
			steps {
                echo "****** Build Application running....******"
				sh "mvn clean package -DskipTests=true"
			}
		}
		
 		stage('Code Coverage ') {
			steps {
				echo "****** Code Coverage running....******"
				echo "Running Code Coverage ..."
				sh "mvn jacoco:report"
			} 
		}
				
    	stage ('Unit Test'){
			steps {
				echo "****** Unit Test running....******"
				sh "mvn test -DskipTests=true" 
			}
		} 

		
 		stage ('File System Scan'){
			steps {
				echo "****** File System scan running....******"
				sh "trivy fs --format table -o trivyscanfs.html ."
			}
		} 
/*		
 		stage('SAST') {
			steps { 
				echo "Running Static application security testing using SonarQube Scanner ..."
				withSonarQubeEnv('mysonarqube') {
					sh 'mvn sonar:sonar -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml -Dsonar.dependencyCheck.jsonReportPath=target/dependency-check-report.json -Dsonar.dependencyCheck.htmlReportPath=target/dependency-check-report.html'
				}
			}
    	}
 		
		stage('QualityGates') { #need sonarqube webhook
			steps { 
				echo "Running Quality Gates to verify the code quality"
				script {
				  timeout(time: 1, unit: 'MINUTES') {
					def qg = waitForQualityGate()		# jenkins will get serv & cred from previous stage
					if (qg.status != 'OK') {
					  error "Pipeline aborted due to quality gate failure: ${qg.status}"
					}
				  }
				}
			}
		}
		
		stage ('Building and Publish Nexus'){
			steps {
				withMaven(globalMavenSettingsConfig: 'maven-settings-mkadir', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true){
					sh "mvn deploy -DskipTests=true"
				}
			}
		} 
 */
		
		stage ('Docker Build & Tag'){
			steps {
				script {
                    echo "****** Docker Build and Tag Image running....******"
					withDockerRegistry(credentialsId: 'docer-cred') {
						sh "docker build -t mskr7/mkadir-bankapp:latest ."
					}
				}
			}
		}

/* 		stage('Build Docker Image') { 			# alternate. better using functions insted of commands
			steps { 
				echo "Build Docker Image"
				script {
					   docker.withRegistry( '', registryCredential ) { 
					        myImage = docker.build registry + ":$BUILD_NUMBER" 
						    myImage.push()
						}	
				}
			}
		

     environment {  #environment variables for previous docker alternate stage
		registry = "mskr7/mkadir-bankapp" 
		registryCredential = 'docdocker-cred' 
	} 

		
		stage ('Docker Image Scan'){ 			
			steps {
                echo "****** Docker Image Scan by Trivy running....******"
				sh "trivy image --scanners vuln --format table -o trivyscandocr.html mskr7/mkadir-bankapp:latest"
			}
		}  need lot of ram
*/		
		stage ('Docker Push'){
			steps {
				script {
                    echo "****** Docker Push Image running....******"
					withDockerRegistry(credentialsId: 'docer-cred') {
						sh "docker push mskr7/mkadir-bankapp:latest"
					}
				}
			}
		}
		
 		stage('Smoke Test') {
			steps { 
				echo "****** Smoke Test Image running....******"
				sh "docker run -d --name smokerun -p 8080:8080 mskr7/mkadir-bankapp:latest"
				sh "sleep 90"
				sh "docker rm --force smokerun"
			}
		} 
		
		stage('Trigger Deployment'){
			steps { 
			   script {
                    echo "****** Deployment running.... ******"
					echo "Next: Trigger CD Pipeline ......" 
				}		
			}
		}
    }		
}