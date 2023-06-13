// Require dependencies
const express = require('express');
const bodyParser = require('body-parser');
const fs = require('fs');
const { exec } = require('child_process');

// Initialize app
const app = express();
app.use(bodyParser.json());

// Define your API Keys
const API_KEY = '171a9efec207386b7984a6b9685d9c4a1557b575'; // Replace with your actual API key
const COMPLETED_API_KEY = '189baab463b118b3a64fde948b649a7432fe0fcb'; // Replace with your actual API key

// Middleware to check for API key
app.use((req, res, next) => {
    const apiKey = req.headers['x-api-key'];

    if (!apiKey) {
        return res.status(403).json({ error: 'No API key provided' });
    }

    if (req.url.startsWith('/completed')) {
        if (apiKey === COMPLETED_API_KEY) {
            next();
        } else {
            return res.status(403).json({ error: 'Invalid API key for this endpoint' });
        }
    } else {
        if (apiKey === API_KEY) {
            next();
        } else {
            return res.status(403).json({ error: 'Invalid API key' });
        }
    }
});

app.post('/prompts', (req, res) => {
    // Check if prompts are provided
    if (!req.body.prompts) {
        return res.status(400).send({ "error": "prompts not provided" });
    }

    // Parse prompts
    let prompts;
    try {
        prompts = JSON.parse(req.body.prompts);
    } catch (e) {
        return res.status(400).send({ "error": "Invalid JSON format" });
    }

    // Execute shell command
	// This returns int similar to 6273723
    const child = exec('./launch.sh');

    // Handling error
    child.stderr.on('data', (data) => {
        console.log(`stderr: ${data}`);
    });

    // Extract instance id
    child.stdout.on('data', (data) => {
        const instanceId = data.trim();

        // Create JSON object with provided prompts
        let jsonObject = {
            "W": 320,
            "H": 569,
            "tiling": false,
            "restore_faces": false,
            "seed": -1,
            "sampler": "DPM++ SDE Karras",
            "seed_resize_from_w": 0,
            "seed_resize_from_h": 0,
            "steps": 30,
            "save_settings": true,
            "save_sample_per_step": false,
            "batch_name": "Deforum_{timestring}",
            "seed_behavior": "iter",
            "seed_iter_N": 1,
            "use_init": false,
            "strength_0_no_init": true,
            "strength": 0.8,
            "init_image": "https://cdn.pixabay.com/photo/2014/03/29/09/17/cat-300572_1280.jpg",
            "use_mask": false,
            "use_alpha_as_mask": false,
            "invert_mask": false,
            "overlay_mask": true,
            "mask_file": "https://deforum.github.io/a1/M1.jpg",
            "mask_contrast_adjust": 1.0,
            "mask_brightness_adjust": 1.0,
            "mask_overlay_blur": 4,
            "fill": 1,
            "full_res_mask": true,
            "full_res_mask_padding": 4,
            "reroll_blank_frames": "reroll",
            "reroll_patience": 10.0,
            "precision": "autocast",
            "C": 4,
            "f": 8,
            "timestring": "",
            "prompts": prompts,
            "animation_prompts_positive": "",
            "animation_prompts_negative": "((anime)), headphones, child, deformed, bad anatomy, disfigured, poorly drawn face, mutation, mutated, extra limb, urly, disgusting, poorly drawnhands, missing limb, floating limb, disconected limb, malformed hands, blurry, ((((mutated hands and fingers)))), watermark, watermarked, oversaturated, censores, distorted hands, amputation, missing hands, doubled face, obese, doubled hands",
            "animation_mode": "3D",
            "max_frames": 600,
            "border": "wrap",
            "angle": "0:(0)",
            "zoom": "0:(1.0025+0.002*sin(1.25*3.14*t/30))",
            "translation_x": "0:(0), 30:(15), 210:(15), 300:(0)",
            "translation_y": "0:(0)",
            "translation_z": "0:(0.2), 60:(10), 300:(15)",
            "transform_center_x": "0:(0.5)",
            "transform_center_y": "0:(0.5)",
            "rotation_3d_x": "0:(0), 60:(0), 90:(0.5), 180:(0.5), 300:(0.5)",
            "rotation_3d_y": "0:(0), 60:(0.2), 90:(0), 180:(-0.5), 300:(0), 420:(0.5), 500:(0.8)",
            "rotation_3d_z": "0:(0)",
            "enable_perspective_flip": false,
            "enable_ddim_eta_scheduling": false,
            "ddim_eta_schedule": "0:(0)",
            "enable_ancestral_eta_scheduling": false,
            "ancestral_eta_schedule": "0:(1)",
            "perspective_flip_theta": "0:(0)",
            "perspective_flip_phi": "0:(0)",
            "perspective_flip_gamma": "0:(0)",
            "perspective_flip_fv": "0:(53)",
            "noise_schedule": "0:(-0.06*(cos(3.141*t/15)**100)+0.06)",
            "strength_schedule": "0: (0.65), 25: (0.55)",
            "contrast_schedule": "0: (1.0)",
            "cfg_scale_schedule": "0: (7)",
            "pix2pix_img_cfg_scale_schedule": "0:(1.5)",
            "enable_subseed_scheduling": false,
            "subseed_schedule": "0:(1)",
            "subseed_strength_schedule": "0:(0)",
            "enable_steps_scheduling": false,
            "steps_schedule": "0: (25)",
            "fov_schedule": "0: (70)",
            "aspect_ratio_schedule": "0: (1)",
            "aspect_ratio_use_old_formula": false,
            "near_schedule": "0: (200)",
            "far_schedule": "0: (10000)",
            "seed_schedule": "0:(s), 1:(-1), \"max_f-2\":(-1), \"max_f-1\":(s)",
            "enable_sampler_scheduling": false,
            "sampler_schedule": "0: (\"Euler a\")",
            "mask_schedule": "0: (\"{video_mask}\")",
            "use_noise_mask": false,
            "noise_mask_schedule": "0: (\"{video_mask}\")",
            "enable_checkpoint_scheduling": false,
            "checkpoint_schedule": "0: (\"model1.ckpt\"), 100: (\"model2.safetensors\")",
            "enable_clipskip_scheduling": false,
            "clipskip_schedule": "0: (2)",
            "enable_noise_multiplier_scheduling": true,
            "noise_multiplier_schedule": "0: (1.05)",
            "kernel_schedule": "0: (5)",
            "sigma_schedule": "0: (1.0)",
            "amount_schedule": "0: (0.05)",
            "threshold_schedule": "0: (0.0)",
            "color_coherence": "LAB",
            "color_coherence_image_path": "",
            "color_coherence_video_every_N_frames": 1.0,
            "color_force_grayscale": false,
            "diffusion_cadence": "2",
            "optical_flow_cadence": "None",
            "cadence_flow_factor_schedule": "0: (1)",
            "optical_flow_redo_generation": "None",
            "redo_flow_factor_schedule": "0: (1)",
            "diffusion_redo": "0",
            "noise_type": "perlin",
            "perlin_octaves": 4,
            "perlin_persistence": 0.5,
            "use_depth_warping": true,
            "depth_algorithm": "Midas-3-Hybrid",
            "midas_weight": 0.2,
            "padding_mode": "border",
            "sampling_mode": "bicubic",
            "save_depth_maps": false,
            "video_init_path": "https://deforum.github.io/a1/V1.mp4",
            "extract_nth_frame": 1,
            "extract_from_frame": 0,
            "extract_to_frame": -1,
            "overwrite_extracted_frames": false,
            "use_mask_video": false,
            "video_mask_path": "https://deforum.github.io/a1/VM1.mp4",
            "resume_from_timestring": false,
            "resume_timestring": "20230512220015",
            "hybrid_generate_inputframes": false,
            "hybrid_generate_human_masks": "None",
            "hybrid_use_first_frame_as_init_image": true,
            "hybrid_motion": "None",
            "hybrid_motion_use_prev_img": false,
            "hybrid_flow_consistency": false,
            "hybrid_consistency_blur": 2,
            "hybrid_flow_method": "RAFT",
            "hybrid_composite": "None",
            "hybrid_use_init_image": false,
            "hybrid_comp_mask_type": "None",
            "hybrid_comp_mask_inverse": false,
            "hybrid_comp_mask_equalize": "None",
            "hybrid_comp_mask_auto_contrast": false,
            "hybrid_comp_save_extra_frames": false,
            "hybrid_comp_alpha_schedule": "0:(0.5)",
            "hybrid_flow_factor_schedule": "0:(1)",
            "hybrid_comp_mask_blend_alpha_schedule": "0:(0.5)",
            "hybrid_comp_mask_contrast_schedule": "0:(1)",
            "hybrid_comp_mask_auto_contrast_cutoff_high_schedule": "0:(100)",
            "hybrid_comp_mask_auto_contrast_cutoff_low_schedule": "0:(0)",
            "parseq_manifest": null,
            "parseq_use_deltas": true,
            "use_looper": false,
            "init_images": "{\n    \"0\": \"https://deforum.github.io/a1/Gi1.png\",\n    \"max_f/4-5\": \"https://deforum.github.io/a1/Gi2.png\",\n    \"max_f/2-10\": \"https://deforum.github.io/a1/Gi3.png\",\n    \"3*max_f/4-15\": \"https://deforum.github.io/a1/Gi4.jpg\",\n    \"max_f-20\": \"https://deforum.github.io/a1/Gi1.png\"\n}",
            "image_strength_schedule": "0:(0.75)",
            "blendFactorMax": "0:(0.35)",
            "blendFactorSlope": "0:(0.25)",
            "tweening_frames_schedule": "0:(20)",
            "color_correction_factor": "0:(0.075)",
            "skip_video_creation": false,
            "fps": 15,
            "make_gif": false,
            "delete_imgs": false,
            "add_soundtrack": "None",
            "soundtrack_path": "https://deforum.github.io/a1/A1.mp3",
            "r_upscale_video": false,
            "r_upscale_model": "realesr-animevideov3",
            "r_upscale_factor": "x2",
            "r_upscale_keep_imgs": true,
            "store_frames_in_ram": false,
            "frame_interpolation_engine": "None",
            "frame_interpolation_x_amount": 2,
            "frame_interpolation_slow_mo_enabled": false,
            "frame_interpolation_slow_mo_amount": 2,
            "frame_interpolation_keep_imgs": false,
            "sd_model_name": "revAnimated_v122.safetensors",
            "sd_model_hash": "3f4fefd9",
            "deforum_git_commit_id": "Unknown"
        };

        // Write JSON object to file
        fs.writeFile(`/usr/share/nginx/boreadesign.com/a89f139bafdb123e10c79617cc522fe047bd9d56/${instanceId}.json`, JSON.stringify(jsonObject, null, 2), 'utf8', function (err) {
            if (err) {
                console.log("An error occurred while writing JSON Object to File.");
                return console.log(err);
            }
            console.log("JSON file has been saved.");
        });

        // Immediately send a response
        res.status(200).send({ message: 'Processing the request.' });
    });
});

app.post('/completed/:id', (req, res) => {
    // Extract id from request parameters
    const id = req.params.id;

    // Check if id is a string containing only digits and not more than 15 characters long
    if (!/^\d{1,15}$/.test(id)) {
        return res.status(400).send({ error: 'Invalid id.' });
    }

    // Replace id in the command
    const command1 = `echo received_file_copy_somewhere_where_accessible`;
    const command2 = `echo execute command_that_tells_the_next_backend_to_shut_down-docker-linux`;

    // Execute the first command
    exec(command1, (error, stdout, stderr) => {
        if (error) {
            return res.status(500).send({ error: 'Error executing first command.' });
        }

        // Execute the second command
        exec(command2, (error, stdout, stderr) => {
            if (error) {
                return res.status(500).send({ error: 'Error executing second command.' });
            }

            return res.send({ message: 'Request received.' });
        });
    });
});

app.listen(3000, () => {
    console.log('Server started on port 3000');
});
