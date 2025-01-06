pipeline {
	agent {							
        label "buildAgent2"	
    }
	
	tools {
		maven 'maven3'			
	}

	environment {
		APP_NAME = "mkadir-registerapp"
        RELEASE = "1.0.0"
        DOCKER_USER = "mskr7"
        DOCKER_PASS = 'docer-cred'
        IMAGE_NAME = "${DOCKER_USER}" + "/" + "${APP_NAME}"
        IMAGE_TAG = "${RELEASE}-${BUILD_NUMBER}"
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
				git branch: 'dev', credentialsId: 'git-cred', url: 'https://github.com/mokadir/mkadir-registerapp.git'
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
		
/*  	stage('Code Coverage ') {
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
		} */ 
		
 		stage('SAST-SonarQube Scanner') {
			steps { 
				echo "****** Static application security testing (SAST) using SonarQube Scanner Running....******"
				withSonarQubeEnv('sonarqube-cred') {
					sh 'mvn sonar:sonar -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml -Dsonar.dependencyCheck.jsonReportPath=target/dependency-check-report.json -Dsonar.dependencyCheck.htmlReportPath=target/dependency-check-report.html'
				}
			}
    	}
 	/* 	need sonarqube webhook. jenkins will get serv & cred from previous stage */
		stage('QualityGates') { 
			steps { 
				echo "****** Quality Gates to verify the code quality Running....******"
				script {
				  timeout(time: 1, unit: 'MINUTES') {
					def qg = waitForQualityGate()
					if (qg.status != 'OK') {
					  error "Pipeline aborted due to quality gate failure: ${qg.status}"
					}
				  }
				}
			}
		}
		
		/* use managed file */
		stage ('Building and Publish Nexus'){
			steps {
				echo "****** Building and Publish Nexus Running....******"
				withMaven(globalMavenSettingsConfig: 'maven-settings-mkadir', jdk: '', maven: 'maven3', mavenSettingsConfig: '', traceability: true){
					sh "mvn deploy -DskipTests=true"
				}
			}
		} 
		
/* 		stage ('Docker Build & Tag'){
			steps {
				script {
                    echo "****** Docker Build and Tag Image running....******"
					withDockerRegistry(credentialsId: 'docer-cred') {
						sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
					}
				}
			}
		}
 */
		/* alternate. better using functions insted of commands */
		stage("Build & Push Docker Image") {
            steps {
                script {
					echo "****** Docker Build and Push Image running....******"
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image = docker.build "${IMAGE_NAME}"
                    }
                    docker.withRegistry('',DOCKER_PASS) {
                        docker_image.push("${IMAGE_TAG}")
                        docker_image.push('latest')
                    }
                }
            }
        }
	  
		

	/* Need lots of RAM */
 /* 		stage ('Docker Image Scan'){ 			
			steps {
                echo "****** Docker Image Scan by Trivy running....******"
				sh "trivy image --scanners vuln --format table -o trivyscandocr.html ${IMAGE_NAME}:${IMAGE_TAG}"
			}
		} */

/* 		stage ('Docker Push'){
			steps {
				script {
                    echo "****** Docker Push Image running....******"
					withDockerRegistry(credentialsId: 'docer-cred') {
						sh "docker push ${IMAGE_NAME}:${IMAGE_TAG}"
					}
				}
			}
		} */
		
/*  	stage('Smoke Test') {
			steps { 
				echo "****** Smoke Test Image running....******"
				sh "docker run -d --name smokerun -p 8080:8080 ${IMAGE_NAME}:${IMAGE_TAG}"
				sh "sleep 90"
				sh "docker rm --force smokerun"
			}
		}  */
		
/* 		stage('Deployment to Webserver-1-Tomcat through Ansible Server/Controller') {
			steps { 
			   script {
                    echo "****** Deployment Webserver-1-Tomcat running.... ******"
					 sshPublisher(publishers: [sshPublisherDesc(configName: 'ansible-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'ansible-playbook /home/ansadmin/build-deploy-webserver-1-tomcat.yml', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '//home/ansadmin', remoteDirectorySDF: false, removePrefix: 'webapp/target', sourceFiles: 'webapp/target/*.war')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
				}		
			}
		} */

/* 		stage('Deployment to Webserver-2-Dockerhost through Ansible Server/Controller') {
			steps { 
			   script {
                    echo "****** Deployment Webserver-2-Dockerhost running.... ******"
					sshPublisher(publishers: [sshPublisherDesc(configName: 'ansible-server', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'ansible-playbook /home/ansadmin/build-deploy-webserver-2-dockerhost.yml', execTimeout: 120000, flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)]) 
				}		
			}
		} */

		stage('Deployment Next') {
			steps { 
			   script {
                    echo "****** Deployment next ******"
				}		
			}
		}

    }

	post {
		always {
			script {
				def jobName = env.JOB_NAME
				def buildNumber = env.BUILD_NUMBER
				def pipelineStatus = currentBuild.result ?: 'UNKNOWN'
				def bannerColor = 
				pipelineStatus.toUpperCase() == 'SUCCESS ? 'green' : 'red'
				
				def body """
					<html>
					<body>
					<div style="border: 4px solid ${bannerColor}; padding: 10px;"> 
					<h2>${jobName} - Build ${buildNumber}</h2>
					<div style="background-color: ${bannerColor}; padding: 10px;">
					<h3 style="color: white; ">Pipeline Status: ${pipelineStatus.toUpperCase()}</h3> 
					</div>
					<p>Check the <a href="${BUILD_URL}">console output</a>.</p>
					</div>
					</body> 
					</html>
				"""
				
				emailext (
					subject: "${jobName} - Build ${build Number} - ${pipelineStatus.toUpperCase()}",
					body: body,
					to: jaiswaladi246@gmail.com",
					from: jenkins@example.com", 
					replyTo: jenkins@example.com', 
					mimeType: text/html',
				)
			}
		}
	}		
}