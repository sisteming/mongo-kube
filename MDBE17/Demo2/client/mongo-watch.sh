#!/bin/bash
mongo_cmd='mongo --host mongo-0.mongo --port 27017 --quiet'
sleep 10
rsInit=0

check_if_alive(){ 
	ping -c 3 $1 > /dev/null 2>/dev/null
	alive=`echo $?` 
	if [[ "$alive" -eq 0 ]]; then 
		#echo "$1 is up" 
		echo 0
	else 
		#echo "$1 is not up yet" 
		echo 1
	fi
}

check_initial_set(){
	echo "Checking initial set"
	node0=`check_if_alive mongo-0.mongo`
	if [[ "$node0" -eq 0 ]]; then
		node1=`check_if_alive mongo-1.mongo`
		if [[ "$node1" -eq 0 ]]; then
			node2=`check_if_alive mongo-2.mongo`
			if [[ "$node2" -eq 0 ]]; then
				echo "Nodes 0 to 2 are up and running"
				rsInit=1	
				isMaster=`$mongo_cmd --eval 'db.isMaster().ismaster'`
				isSecondary=`$mongo_cmd --eval 'db.isMaster().secondary'`
				if [[ "$isMaster" == "false" ]] && [[ "$isSecondary" == "false" ]]; then
					configure_replica_set
				fi
			fi
		fi
	else
		echo "Nodes 0 to 2 are not ready yet"
	fi
}

configure_replica_set(){
	$mongo_cmd --eval 'rs.initiate()'
	$mongo_cmd --eval 'var cfg = rs.conf();cfg.members[0].host="mongo-0.mongo:27017";rs.reconfig(cfg)'
	$mongo_cmd --eval 'rs.add("mongo-1.mongo:27017")'
	$mongo_cmd --eval 'rs.add("mongo-2.mongo:27017")'
	sleep 5
	members=`$mongo_cmd --eval 'rs.status().members.length'`
	if [[ "$members" -eq 3 ]]; then
		echo "Replica set configured successfully."
		rsInit=1
		echo 0
	else
		echo "Replica set not fully configured."
		echo 1
	fi
}

scale_replica_set(){
	isMaster=`$mongo_cmd --eval 'db.isMaster().ismaster'`
	if [[ "$isMaster" == "true" ]]; then
		members=`$mongo_cmd --eval 'rs.status().members.length'`
	
		new_node="mongo-$members.mongo"
		new_member=`check_if_alive $new_node`
		
		if [[ "$new_member" -eq 0 ]]; then
			echo ""
			echo "Adding mongo-$members.mongo to the replica set."
			add_node_to_replica_set "mongo-$members.mongo"
		else
			printf "."
		fi
	fi

}

add_node_to_replica_set(){
	$mongo_cmd --eval "rs.add('$1:27017')"
}

#### MAIN LOGIC
echo "Searching for initial replica set..."
while [[ "$rsInit" -eq 0 ]]
do
	
	check_initial_set

	#echo "Still inside config loop"
	sleep 5
done

printf "Monitoring MongoDB replica set to scale..."
while true
do
	scale_replica_set
	#echo "Still inside scaling loop"
	sleep 5
done

