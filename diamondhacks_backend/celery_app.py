from celery import Celery

celery_app = Celery(
    "HandWriting",
    backend="",
    broker=""
)



celery_app.conf.update({
                        'worker_prefetch_multiplier': 1,
                        'task_acks_late': True,
                        'task_track_started': True,
                        'result_expires': 604800,
                        "result_extended": False,
                        'task_reject_on_worker_lost': True,
                        'task_queue_max_priority': 10,
                        'worker_send_task_events':True
                        })

celery_app.conf.task_routes = {
        "QG": "default"}
