#!/usr/bin/env bash
{
	hostname ethan.public-records.iad
	echo 'ethan.public-records.iad' > /etc/hostname
	rm /etc/salt/minion_id
	service salt-minion restart
	rm /etc/consul.d/health-checks/iamanode.py
	echo 'is_pr_server: True' >> /etc/salt/grains
	salt-call state.highstate
	consul maint -disable
	stop consul
	start consul
	status consul
	python pr_update_cf.py
} ||
	{
		echo 'This script failed'
	}
	echo 'Dude this always happens'
